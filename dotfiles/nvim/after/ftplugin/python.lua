local keymapper = require('helpers.keymapper')

vim.opt_local.colorcolumn = '79'
vim.opt_local.textwidth = 79

keymapper.buffer_nnoremap('<leader>b', 'obreakpoint()<Esc>')
keymapper.buffer_nnoremap('<leader>B', 'Obreakpoint()<Esc>')

keymapper.buffer_nnoremap('gl', ':TestVisit<CR>')

keymapper.buffer_nnoremap('<a-f>', ':TestFile -strategy=pytslime<CR>')
keymapper.buffer_nnoremap('<a-l>', ':TestLast -strategy=pytslime<CR>')
keymapper.buffer_nnoremap('<a-t>', ':TestNearest -strategy=pytslime<CR>')

keymapper.buffer_nnoremap('<a-F>', ':TestFile -strategy=pytslimedebug<CR>')
keymapper.buffer_nnoremap('<a-L>', ':TestLast -strategy=pytslimedebug<CR>')
keymapper.buffer_nnoremap('<a-T>', ':TestNearest -strategy=pytslimedebug<CR>')
