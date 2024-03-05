local keymapper = require("helpers.keymapper")

<<<<<<< HEAD
vim.opt_local.colorcolumn = '100'
vim.opt_local.textwidth = 100

=======
>>>>>>> 6dfa242cf74ba7c22c0d2d93867ecf6041d725df
keymapper.buffer_nnoremap('<leader>b', 'obreakpoint()<Esc>')
keymapper.buffer_nnoremap('<leader>B', 'Obreakpoint()<Esc>')
keymapper.buffer_nnoremap('<leader><leader>n', ':setlocal tw=0<CR>A  # noqa<Esc>^<cmd>setlocal tw=79<CR>')

keymapper.buffer_nnoremap('gl', ':TestVisit<CR>')

keymapper.buffer_nnoremap('<a-f>', ':TestFile -strategy=pytesttmux<CR>')
keymapper.buffer_nnoremap('<a-l>', ':TestLast -strategy=pytesttmux<CR>')
keymapper.buffer_nnoremap('<a-t>', ':TestNearest -strategy=pytesttmux<CR>')

keymapper.buffer_nnoremap('<a-F>', ':TestFile -strategy=pytesttmuxdebug<CR>')
keymapper.buffer_nnoremap('<a-L>', ':TestLast -strategy=pytesttmuxdebug<CR>')
keymapper.buffer_nnoremap('<a-T>', ':TestNearest -strategy=pytesttmuxdebug<CR>')
