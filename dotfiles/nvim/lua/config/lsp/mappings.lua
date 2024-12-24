local m = require("helpers.keymapper")
local helpers = require("helpers.lsp")

---@class MappingsLsp
---@field on_lsp_attach function Set up mappings that apply to all LSP servers
---@field map_code_action function Map a keybinding to trigger code actions
local M = {}

---@class LspAttachArgs
---@field buf number
---@field data table {client_id: number}
---@field event string
---@field file string
---@field id number
---@field match string

--- Set up mappings that apply to all LSP servers
---@param args LspAttachArgs
function M.on_lsp_attach(args)
    m.buffer_nnoremap("<C-k>", vim.lsp.buf.hover)
    m.buffer_nnoremap("<C-s>", vim.lsp.buf.signature_help)
    m.buffer_nnoremap("<leader>f", vim.lsp.buf.format)
    m.buffer_nnoremap("<space>lua", helpers.underline.all)
    m.buffer_nnoremap("<space>lue", helpers.underline.error)
    m.buffer_nnoremap("<space>luo", helpers.underline.off)
    m.buffer_nnoremap("<space>lva", helpers.virtualtext.all)
    m.buffer_nnoremap("<space>lve", helpers.virtualtext.error)
    m.buffer_nnoremap("<space>lvo", helpers.virtualtext.off)
    m.buffer_nnoremap("gra", vim.lsp.buf.code_action)
    m.buffer_nnoremap("grn", vim.lsp.buf.rename)
    m.buffer_nnoremap("grr", vim.lsp.buf.references)
end

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
