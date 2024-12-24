local m = require("helpers.keymapper")

---@class LspMappings
---@field map_code_action function Map a keybinding to trigger code actions
local M = {}

--- Set up a mapping for code actions
---@param code_action_kinds string[] The kinds of code actions to apply
---@param mapping string? The mapping to use (default: "<leader>a")
function M.map_code_action(code_action_kinds, mapping)
    mapping = mapping or "<leader>a"
    m.buffer_nnoremap(mapping, function()
        vim.lsp.buf.code_action({
            context = { only = code_action_kinds, diagnostics = {} },
            apply = true,
        })
    end)
end

return M
