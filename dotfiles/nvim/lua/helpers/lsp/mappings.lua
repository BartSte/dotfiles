local m = require("helpers.keymapper")

---@class LspMappings
---@field map_formatter function(client: vim.lsp.Client, buf: integer): function
local M = {}

---@class FormatterOpts
---@field mapping string? The mapping to use (default: "<leader>f")
---@field actions string[]? The code action kinds to apply alongside
---@field client_name string? The name of the client to use
local defaults = {
    mapping = "<leader>f",
    actions = {},
    client_name = ""
}

--- Map a formatter function to a keybinding
---@param opts FormatterOpts The options to use for the formatter
---the vim.lsp.buf.format call.
---@return function formatter The formatter function
function M.map_formatter(opts)
    opts = vim.tbl_extend("force", defaults, opts)
    local formatter = function()
        M.run_actions(opts.actions)
        vim.lsp.buf.format({ timeout_ms = 5000 })
    end
    m.buffer_nnoremap(opts.mapping, formatter)
end

function M.run_actions(actions)
    if actions then
        vim.lsp.buf.code_action({
            context = { only = actions, diagnostics = {} },
            apply = true
        })
    end
end

return M
