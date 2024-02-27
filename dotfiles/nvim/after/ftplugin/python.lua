local keymapper = require('helpers.keymapper')

vim.opt_local.colorcolumn = '79'
vim.opt_local.textwidth = 79

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

vim.opt_local.formatprg = 'autopep8 -'

-- map leader + f to format the entire file. This can be done using gggqG, but
-- we need to make sure the cursor is returned to the original position. This
-- can be done by jumping two times back in the jump list.
keymapper.buffer_nnoremap('<leader>f', 'gggqG')

