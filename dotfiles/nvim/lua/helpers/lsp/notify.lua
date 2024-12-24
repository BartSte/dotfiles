---@class Notify
---@field attach function
---@field attach_decorator function
---@field progress_per_client table
---@field progress function
local M = {}
local attach_msg = {}
local attached_once = {}

--- Return the list of clients that have been attached to a buffer of a specific
--- filetype at least once
---@param buf integer
---@return string[] A list of client names
local function get_attached_once(buf)
    local ft = vim.bo[buf].filetype
    if not attached_once[ft] then
        attached_once[ft] = {}
    end
    return attached_once[ft]
end

--- Update the list of clients that have been attached to a buffer of a specific
--- filetype
---@param client vim.lsp.Client
---@param buf integer
local function update_attached_once(client, buf)
    table.insert(get_attached_once(buf), client.name)
end

--- Check if a client has been attached to a buffer of a specific filetype
---@param client vim.lsp.Client
---@param buf integer
---@return boolean
local function is_attached_once(client, buf)
    return vim.tbl_contains(get_attached_once(buf), client.name)
end

local function get_attach_msg(buf)
    local ft = vim.bo[buf].filetype
    if attach_msg[ft] == nil then
        attach_msg[ft] = {}
    end
    return attach_msg[ft]
end

--- Append the formatting capabilities to the attach message
local function update_attach_msg(client, buf)
    local msg = client.name
    local has_document_formatting = client.server_capabilities.documentFormattingProvider
    local has_range_formatting = client.server_capabilities.documentRangeFormattingProvider

    if has_document_formatting and has_range_formatting then
        msg = msg .. " -> format"
    elseif has_document_formatting then
        msg = msg .. " -> document format"
    elseif has_range_formatting then
        msg = msg .. " -> range format"
    end

    table.insert(get_attach_msg(buf), msg)
end

--- Notify about which clients are attached
---@param client vim.lsp.Client
---@param buf integer
M.attach = function(client, buf)
    if not is_attached_once(client, buf) then
        update_attached_once(client, buf)
        update_attach_msg(client, buf)

        local ft = vim.bo[buf].filetype
        msg_ids.lsp_attached[ft] = Snacks.notify.info(
            get_attach_msg(buf), {
                id = msg_ids.lsp_attached[ft],
                title = "LSP Attached: " .. vim.bo[buf].filetype,
            }
        )
    end
end

--- Decorator for the `on_attach` function
---@param fn nil|function(client: vim.lsp.Client, buf: integer): void
---@return function
M.attach_decorator = function(fn)
    return function(client, buf)
        M.attach(client, buf)
        if fn then
            return fn(client, buf)
        end
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
