local map = require("helpers.keymapper")

-- Move from the source to corresponding test file and vice versa. The following
-- is assumed:
-- - The source file is in a directory named `./src/<package>/path/to/file.py`
-- - The test file is in a directory named `./tests/test_path/test_to/test_file.py`
local function toggle_test_file()
    local rel_path = vim.fn.expand('%:p:~:.')
    local is_src = vim.fn.match(rel_path, 'src/') ~= -1
    local new_path = ""
    if is_src then
        new_path = vim.fn.substitute(rel_path, 'src/[^/]*', 'tests', '')
        new_path = vim.fn.substitute(new_path, "/", "/test_", "g")
    else
        new_path = vim.fn.substitute(rel_path, 'tests[^/]*', 'src/*/', '')
        new_path = vim.fn.substitute(new_path, "/test_", "/", "g")
    end
    new_path = vim.fn.substitute(new_path, "//", "/", "g")
    vim.cmd('edit ' .. new_path)
end


map.buffer_nnoremap('<leader>b', 'obreakpoint()<Esc>')
map.buffer_nnoremap('<leader>B', 'Obreakpoint()<Esc>')

map.buffer_nnoremap('gl', ':TestVisit<CR>')
map.buffer_nnoremap('gs', toggle_test_file)

map.buffer_nnoremap('<a-f>', ':TestFile -strategy=pytesttmux<CR>')
map.buffer_nnoremap('<a-l>', ':TestLast -strategy=pytesttmux<CR>')
map.buffer_nnoremap('<a-t>', ':TestNearest -strategy=pytesttmux<CR>')

map.buffer_nnoremap('<a-F>', ':TestFile -strategy=pytesttmuxdebug<CR>')
map.buffer_nnoremap('<a-L>', ':TestLast -strategy=pytesttmuxdebug<CR>')
map.buffer_nnoremap('<a-T>', ':TestNearest -strategy=pytesttmuxdebug<CR>')

require("projectrc").require("after.ftplugin.python").setup()
