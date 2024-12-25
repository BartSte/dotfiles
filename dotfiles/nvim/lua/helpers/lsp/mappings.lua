local m = require("helpers.keymapper")
local helpers = require("helpers.lsp.capabilities")

---@class LspMappings
---@field map_formatter function(client: vim.lsp.Client, buf: integer): function
local M = {}

---@class FormatterOpts
---@field mapping string? The mapping to use (default: "<leader>f")
---@field actions string[]? The code action kinds to apply alongside
---@field client_name string? The name of the client to use
local defaults = {
    mapping = "<leader>f",
    actions = nil,
}

--- Map a formatter function to a keybinding that is also able to run code
--- actions alongside the formatter.
---@param client vim.lsp.Client The client to use for the formatter
---@param opts FormatterOpts? The options to use for the formatter
---the vim.lsp.buf.format call.
---@return function formatter The formatter function
function M.map_formatter(client, opts)
    opts = opts or {}
    opts = vim.tbl_extend("force", defaults, opts)
    local formatter = M.make_formatter(client, opts.actions)
    if formatter then
        m.buffer_nnoremap(opts.mapping, formatter)
    end
end

--- Create a formatter function that can run code actions alongside the formatter.
---@param client vim.lsp.Client The client to use for the formatter
---@param actions string[]|nil The code action kinds to apply alongside the formatter
---@return function formatter The formatter function
function M.make_formatter(client, actions)
    local has_formater = helpers.has_capability(client, "documentFormattingProvider")
    if has_formater or actions then
        return function()
            M.run_actions(actions)
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
