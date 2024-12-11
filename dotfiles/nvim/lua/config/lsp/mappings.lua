local m = require("helpers.keymapper")
local helpers = require("helpers.lsp")

---@class MappingsLsp
---@field set function
local M = {}

local function format()
    vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" }, diagnostics = {} },
        apply = true,
    })
    vim.lsp.buf.format({ timeout_ms = 5000, async = false })
end

---Set up mappings for LSP
--@param args table {buf: number, data: table {client_id: number}, event: string, file: string, id: number, match: string}
function M.set(args)
    m.buffer_nnoremap("<C-k>", vim.lsp.buf.hover)
    m.buffer_nnoremap("<C-s>", vim.lsp.buf.signature_help)
    m.buffer_nnoremap("<space>f", format)
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

return M
