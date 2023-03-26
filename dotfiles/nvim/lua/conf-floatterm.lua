local keymapper = require('keymapper')

if vim.fn.has('win32') == 0 then
    vim.g.floaterm_title = os.getenv('SHELL') .. " @ " .. os.getenv('PWD') .. ": $1/$2"
else
    vim.g.floaterm_title = "Powershell: $1/$2"
end
vim.g.floaterm_wintype = 'float'
vim.g.floaterm_width = 0.95
vim.g.floaterm_height = 0.95
vim.g.floaterm_position = 'center'
vim.g.floaterm_autoclose = 2
vim.g.floaterm_autoinsert = false

keymapper.nnoremap('<a-q>', ':FloatermToggle<CR>')
