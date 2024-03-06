local map = require("helpers.keymapper")

--Work around for bug in LSP -> all marks are deleted after format.
local function format()
    vim.lsp.buf.format({ async = true })
end

vim.opt_local.textwidth = 80
map.buffer_nnoremap("<space>f", format)
