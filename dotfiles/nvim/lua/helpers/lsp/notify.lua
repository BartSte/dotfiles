---@class Notify
---@field attach function
---@field progress_per_client table
---@field progress function
local M = {}

---@type table<string, integer[]>
local attached = {}

---@type table<string, integer>
local msg_id = {}

--- Return the list of clients that have been attached to a buffer of a specific
--- filetype at least once
---@param buf integer
---@return integer[] ids The list of client ids
local function get_attached(buf)
    local ft = vim.bo[buf].filetype
    attached[ft] = attached[ft] or {}
    return attached[ft]
end

--- Update the list of clients that have been attached to a buffer of a specific
--- filetype
---@param client vim.lsp.Client
---@param buf integer
local function update_attached(client, buf)
    table.insert(get_attached(buf), client.id)
end

--- Check if a client has been attached to a buffer of a specific filetype
---@param client vim.lsp.Client
---@param buf integer
---@return boolean
local function is_attached(client, buf)
    return vim.tbl_contains(get_attached(buf), client.name)
end

local function make_attach_msg(buf)
    local result = ""
    local client_ids = get_attached(buf)
    for _, id in ipairs(client_ids) do
        local client = vim.lsp.get_client_by_id(id)
        if client then
            result = result .. "\n" .. client.name
            local extras = {}
            if client.server_capabilities.documentFormattingProvider then
                table.insert(extras, "document")
            end
            if client.server_capabilities.documentRangeFormattingProvider then
                table.insert(extras, "range")
            end
            -- `format_actions` is a custom field
            if client.server_capabilities.format_actions then
                table.insert(extras, "actions")
            end
            if #extras > 0 then
                result = result .. " -> format: " .. table.concat(extras, ", ")
            end
        end
    end
    return result
end

--- Notify about which clients are attached
---@param client vim.lsp.Client
---@param buf integer
M.attach = function(client, buf)
    if not is_attached(client, buf) then
        update_attached(client, buf)

        local ft = vim.bo[buf].filetype
        local msg = make_attach_msg(buf)
        local title = "LSP Attached: " .. ft
        msg_id[ft] = Snacks.notify.info(msg, { title = title, id = msg_id[ft] })
    end
end

M.progress_per_client = vim.defaulttable()
---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
M.progress = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value
    if not client or type(value) ~= "table" then
        return
    end
    local p = M.progress_per_client[client.id]

    for i = 1, #p + 1 do
        if i == #p + 1 or p[i].token == ev.data.params.token then
            p[i] = {
                token = ev.data.params.token,
                msg = ("[%3d%%] %s%s"):format(
                    value.kind == "end" and 100 or value.percentage or 100,
                    value.title or "",
                    value.message and (" **%s**"):format(value.message) or ""
                ),
                done = value.kind == "end",
            }
            break
        end
    end

    local msg = {} ---@type string[]
    M.progress_per_client[client.id] = vim.tbl_filter(function(v)
        return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(table.concat(msg, "\n"), "info", {
        id = "lsp_progress",
        title = client.name,
        opts = function(notif)
            notif.icon = #M.progress_per_client[client.id] == 0 and " "
                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
        end,
    })
end

return M
