local keymapper = require("helpers.keymapper")

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
