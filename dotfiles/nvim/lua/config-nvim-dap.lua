local dap = require('dap')
local dap_python = require('dap-python')
local widgets = require('dap.ui.widgets')
local keymapper = require('keymapper')

dap_python.setup()
dap_python.test_runner = 'unittest'

vim.keymap.set('n', '<F4>', function() dap.run_last() end)
vim.keymap.set('n', '<F5>', function() dap.continue() end)
vim.keymap.set('n', '<F9>', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<F10>', function() dap.step_over() end)
vim.keymap.set('n', '<F11>', function() dap.step_into() end)
vim.keymap.set('n', '<F12>', function() dap.step_out() end)

vim.keymap.set('n', '<a-R>', function() dap.repl.open() end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function() widgets.hover() end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function() widgets.preview() end)
vim.keymap.set('n', '<Leader>df', function() widgets.centered_float(widgets.frames) end)
vim.keymap.set('n', '<Leader>ds', function() widgets.centered_float(widgets.scopes) end)
vim.keymap.set('n', '<Leader>dl', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)

keymapper.nnoremap('<a-C>', ':lua require("dap-python").test_class()<CR>')
keymapper.nnoremap('<a-T>', ':lua require("dap-python").test_method()<CR>')
keymapper.vnoremap('<a-T>', ':lua require("dap-python").test_selection()<CR>')

dap.defaults.fallback.terminal_win_cmd = '50vsplit new'

vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
