local map = require("helpers.keymapper")
local helpers = require("helpers.python")

map.buffer_nnoremap('<leader>b', 'obreakpoint()<Esc>')
map.buffer_nnoremap('<leader>B', 'Obreakpoint()<Esc>')

map.buffer_nnoremap('gl', ':TestVisit<CR>')
map.buffer_nnoremap('gs', helpers.toggle_test_file)
map.buffer_nnoremap('<C-w>a', helpers.split_window_src_test)

map.buffer_nnoremap('<a-f>', ':TestFile -strategy=pytesttmux<CR>')
map.buffer_nnoremap('<a-l>', ':TestLast -strategy=pytesttmux<CR>')
map.buffer_nnoremap('<a-t>', ':TestNearest -strategy=pytesttmux<CR>')

map.buffer_nnoremap('<a-F>', ':TestFile -strategy=pytesttmuxdebug<CR>')
map.buffer_nnoremap('<a-L>', ':TestLast -strategy=pytesttmuxdebug<CR>')
map.buffer_nnoremap('<a-T>', ':TestNearest -strategy=pytesttmuxdebug<CR>')

require("projectrc").require("after.ftplugin.python").setup()
