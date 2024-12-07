local m = require("helpers.keymapper")
local helpers = require("helpers.lsp")

local function mappings()
    m.buffer_nnoremap("<C-k>", vim.lsp.buf.hover)
    m.buffer_nnoremap("<C-s>", vim.lsp.buf.signature_help)
    m.buffer_nnoremap("<space>f", helpers.format)
    m.buffer_nnoremap("<space>lua", helpers.underline.all)
    m.buffer_nnoremap("<space>lue", helpers.underline.error)
    m.buffer_nnoremap("<space>luo", helpers.underline.off)
    m.buffer_nnoremap("<space>lva", helpers.virtual_text.all)
    m.buffer_nnoremap("<space>lve", helpers.virtual_text.error)
    m.buffer_nnoremap("<space>lvo", helpers.virtual_text.off)
    m.buffer_nnoremap("gra", vim.lsp.buf.code_action)
    m.buffer_nnoremap("grn", vim.lsp.buf.rename)
    m.buffer_nnoremap("grr", vim.lsp.buf.references)
end

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = mappings
})
