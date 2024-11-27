local map = require("helpers.keymapper")
local helpers = require("helpers.python")

map.buffer_nnoremap('<leader>b', 'obreakpoint()<Esc>')
map.buffer_nnoremap('<leader>B', 'Obreakpoint()<Esc>')

map.buffer_nnoremap('gl', ':TestVisit<CR>')
map.buffer_nnoremap('gs', helpers.toggle_test_file)
map.buffer_nnoremap('gS', helpers.split_window_src_test)

map.buffer_nnoremap('<leader>tf', ':TestFile -strategy=pytesttmux<CR>')
map.buffer_nnoremap('<leader>tl', ':TestLast -strategy=pytesttmux<CR>')
map.buffer_nnoremap('<leader>tt', ':TestNearest -strategy=pytesttmux<CR>')
map.buffer_nnoremap('<leader>tF', ':TestFile -strategy=pytesttmuxdebug<CR>')
map.buffer_nnoremap('<leader>tL', ':TestLast -strategy=pytesttmuxdebug<CR>')
map.buffer_nnoremap('<leader>tT', ':TestNearest -strategy=pytesttmuxdebug<CR>')

require("projectrc").require("after.ftplugin.python").setup()
