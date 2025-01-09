local fn = require("helpers.fn")
local null_ls = require("null-ls")
local capabilities = require("helpers.lsp.capabilities")

--- The clients that have been attached to a buffer of a specific filetype.
---@type table<vim.lsp.Client|NullLsSource>
local attached = {}

---@type table<string, integer>
local msg_id = {}

--- Return the list of clients that have been attached to a buffer of a specific
--- filetype at least once
---@param buf integer
---@return table <vim.lsp.Client|NullLsSource>
local function get_attached(buf)
    local ft = vim.bo[buf].filetype
    attached[ft] = attached[ft] or {}
    return attached[ft]
end

--- Check if a client has been attached to a buffer of a specific filetype. Only
--- the server name needs to match, as each server is only displayed once per
--- filetype.
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
    return false
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

--- Create a message that lists the names of the clients that have been attached
--- to a buffer of a specific filetype. In addition, also specify if a client
--- has one or more of the following formatting capabilities: document, range,
--- or a code action.
---@param buf integer
---@return string message A table with a headers: name, range, document, actions
---and a row for each client that has been attached to the buffer. For example:
-- | name | range | document | actions |
-- | ruff |   x   |    x     |         |
local function make_attach_msg(buf)
    local header = { "name", "range", "document", "actions" }
    local rows = {}
    local clients = get_attached(buf)
    for _, client in ipairs(clients) do
        local is_lsp = client.server_capabilities ~= nil
        local is_null_ls = client.methods ~= nil
        if is_lsp then
            rows[#rows + 1] = {
                client.name,
                capabilities.has_capability(client, "documentRangeFormattingProvider") and "x" or "",
                capabilities.has_capability(client, "documentFormattingProvider") and "x" or "",
                capabilities.has_capability(client, "format_actions") and "x" or "",
            }
        elseif is_null_ls then
            rows[#rows + 1] = {
                client.name,
                capabilities.has_capability(client, null_ls.methods.RANGE_FORMATTING) and "x" or "",
                capabilities.has_capability(client, null_ls.methods.FORMATTING) and "x" or "",
                "" -- not supported yet for null-ls
            }
        end
    end
    return fn.tabulate(header, rows)
end

local progress_per_client = vim.defaulttable()

---@class Notify
---@field attach function
---@field progress function
local M = {}

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

--- Notify about the progress of a request.
---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
M.progress = function(ev)
    if vim.v.exiting ~= vim.NIL then
        return
    end

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value
    if not client or type(value) ~= "table" then
        return
    end
    local p = progress_per_client[client.id]

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
    progress_per_client[client.id] = vim.tbl_filter(function(v)
        return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO, {
        id = "lsp_progress",
        title = client.name,
        opts = function(notif)
            notif.icon = #progress_per_client[client.id] == 0 and " "
                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
        end,
    })
end

return M
