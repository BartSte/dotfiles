-- local dappy = require('dap-python')
local keymapper = require('helpers.keymapper')

vim.opt_local.colorcolumn = '79'
vim.opt_local.textwidth = 79

-- local opts = {
--     config = {
--         justMyCode = true,
--         subProcess = false,
--     }
-- }

keymapper.buffer_nnoremap('<leader>b', 'obreakpoint()<Esc>')
keymapper.buffer_noremap('<leader>B', 'Obreakpoint()<Esc>')
-- vim.keymap.set('n', '<a-C>', function() dappy.test_class(opts) end)
-- vim.keymap.set('n', '<a-T>', function() dappy.test_method(opts) end)
-- vim.keymap.set('n', '<a-S>', function() dappy.test_selection(opts) end)
