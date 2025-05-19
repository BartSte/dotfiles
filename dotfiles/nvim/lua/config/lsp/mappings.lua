local m = require("helpers.keymapper")

---@class MappingsLsp
---@field on_lsp_attach function Set up mappings that apply to all LSP servers
local M = {}

--- Set up mappings that apply to all LSP servers
function M.on_lsp_attach(client, buf)
    local helpers = require("helpers.lsp")
    m.buffer_nnoremap("<C-s>", vim.lsp.buf.signature_help)
    m.buffer_nnoremap("<space>lua", helpers.underline.all)
    m.buffer_nnoremap("<space>lue", helpers.underline.error)
    m.buffer_nnoremap("<space>luo", helpers.underline.off)
    m.buffer_nnoremap("<space>lva", helpers.virtualtext.all)
    m.buffer_nnoremap("<space>lve", helpers.virtualtext.error)
    m.buffer_nnoremap("<space>lvo", helpers.virtualtext.off)
    m.buffer_nnoremap("gra", vim.lsp.buf.code_action)
    m.buffer_nnoremap("grn", vim.lsp.buf.rename)
    m.buffer_nnoremap("grr", vim.lsp.buf.references)
    helpers.mappings.map_formatter(client, buf)
end

return M
