local m = require("helpers.keymapper")
local helpers = require("helpers.lsp.capabilities")

---@class LspMappings
---@field map_formatter function(client: vim.lsp.Client, buf: integer): function
local M = {}

--- Map a formatter function to a keybinding that is also able to run code
--- actions alongside the formatter.
---@param client CustomClient The client to use for the formatter
---@param lhs string The keybinding to map to the formatter
---@return function formatter The formatter function
function M.map_formatter(client, lhs)
    local formatter = M.make_formatter(client)
    if formatter then
        m.buffer_nnoremap(lhs or "<space>f", formatter)
    end
end

--- Create a formatter function that can run code actions alongside the formatter.
---@param client CustomClient The client to use for the formatter
---@return function formatter The formatter function
function M.make_formatter(client)
    -- `format_actions` is a custom capability that is not part of the LSP spec
    local has_actions = helpers.has_capability(client, "format_actions")
    local has_formater = helpers.has_capability(client, "documentFormattingProvider")
    if has_formater or has_actions then
        return function()
            M.run_actions(client.server_capabilities.format_actions)
            M.format(client)
        end
    end
end

--- Run code actions on the current buffer.
---@param actions string[]|nil The code action kinds to apply
function M.run_actions(actions)
    if actions then
        vim.lsp.buf.code_action({
            context = { only = actions, diagnostics = {} },
            apply = true
        })
    end
end

--- Format the current buffer using the LSP client.
---@param client vim.lsp.Client The client to use for the formatter
function M.format(client)
    if client.server_capabilities.documentFormattingProvider then
        vim.lsp.buf.format({ timeout_ms = 5000 })
    end
end

return M
