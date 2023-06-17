--Work around for bug in LSP -> all marks are deleted after format.
local function format()
    vim.lsp.buf.format({ async = true })
end

local opts = { buffer = true }

vim.b.textwidth = 79
vim.keymap.set('n', '<space>f', format, opts)