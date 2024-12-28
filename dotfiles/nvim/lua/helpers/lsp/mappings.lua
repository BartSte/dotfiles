local m = require("helpers.keymapper")
local fn = require("helpers.fn")
local helpers = require("helpers.lsp.capabilities")

---@class LspMappings
---@field map_formatter function(client: vim.lsp.Client, buf: integer): function
local M = {}

--- Run a formatter on the current buffer.
---@return function formatter The formatter function
local function make_buf_format()
    return function()
        vim.lsp.buf.format({ timeout = 5000 })
    end
end

--- Run code actions on the current buffer.
---@param client vim.lsp.Client The client to use for the actions
local function make_run_actions(client)
    vim.lsp.buf.code_action({
        context = { only = client.server_capabilities.format_actions, diagnostics = {} },
        apply = true
    })
end

--- Map a formatter function to a keybinding that is also able to run code
--- actions alongside the formatter.
---@param client vim.lsp.Client The client to use for the formatter
---@param lhs string The keybinding to map to the formatter
---@return function formatter The formatter function
function M.map_formatter(client, lhs)
    local formatter = M.make_formatter(client)
    if formatter then
        m.buffer_nnoremap(lhs or "<space>f", formatter)
    end
end

--- Create a formatter function that can run code actions alongside the formatter.
---@param client vim.lsp.Client The client to use for the formatter
---@return function|nil formatter The formatter function
function M.make_formatter(client)
    local result = nil

    -- `format_actions` is a custom capability that is not part of the LSP spec
    local has_formater = helpers.has_capability(client, "documentFormattingProvider")
    if has_formater then
        result = make_buf_format()
    end

    local has_actions = helpers.has_capability(client, "format_actions")
    if has_actions then
        result = fn.decorate({ result, make_run_actions(client) })
    end

    return result
end

return M
