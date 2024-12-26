---@class Notify
---@field attach function
---@field progress_per_client table
---@field progress function
local M = {}

--- Only the essentials of the client are stored.
---@type vim.lsp.Client[]|NullLsSource[]
local attached = {}

---@type table<string, integer>
local msg_id = {}

--- Return the list of clients that have been attached to a buffer of a specific
--- filetype at least once
---@param buf integer
---@return vim.lsp.Client[]|NullLsSource[]
local function get_attached(buf)
    local ft = vim.bo[buf].filetype
    attached[ft] = attached[ft] or {}
    return attached[ft]
end

--- Check if a client has been attached to a buffer of a specific filetype. Only
--- the server name needs to match.
---@param client vim.lsp.Client|NullLsSource
---@param buf integer
---@return boolean
local function is_attached(client, buf)
    local servers = get_attached(buf)
    for _, server in ipairs(servers) do
        if server.name == client.name then
            return true
        end
    end
end

--- Update the list of clients that have been attached to a buffer of a specific
--- filetype
---@param client vim.lsp.Client|NullLsSource
---@param buf integer
local function update_attached(client, buf)
    if not is_attached(client, buf) then
        table.insert(get_attached(buf), client)
    end
end

local function make_attach_msg(buf)
    local result = ""
    local clients = get_attached(buf)
    for _, client in ipairs(clients) do
        result = result .. "\n" .. client.name
        local extras = {}

        if client.methods then
            extras = vim.tbl_keys(client.methods)
        elseif client.server_capabilities then
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
        end

        if #extras > 0 then
            result = result .. " -> format: " .. table.concat(extras, ", ")
        end
    end
    return result
end

--- Notify about which clients are attached.
--- Each lsp is only show once for each filetype to avoid this message to popup
--- after opening every file.
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
