local dap = require('dap')
local path = require('helpers.os_path')
-- local dappy = require('dap-python')
local vscode = require('dap.ext.vscode')
local helpers = require('helpers.dap')
local widgets = require('dap.ui.widgets')
local keymapper = require('helpers.keymapper')
local my_launch = path.path_join(path.get_home(), 'dotfiles/launch.json')

dap.defaults.fallback.terminal_win_cmd = '80vsplit new'
dap.defaults.fallback.focus_terminal = false

vscode.load_launchjs('.vscode/launch.json')
vscode.load_launchjs(my_launch)

-- dappy.setup(helpers.get_debugpy())
-- dappy.test_runner = 'pytest'

vim.keymap.set('n', '<F4>', dap.run_last)
vim.keymap.set('n', '<F5>', dap.continue)
vim.keymap.set('n', '<F9>', dap.toggle_breakpoint)
vim.keymap.set('n', '<F10>', dap.step_over)
vim.keymap.set('n', '<F11>', dap.step_into)
vim.keymap.set('n', '<F12>', dap.step_out)
vim.keymap.set('n', '<a-R>', dap.repl.open)
vim.keymap.set({ 'n', 'v' }, '<Leader>dh', widgets.hover)
vim.keymap.set({ 'n', 'v' }, '<Leader>dp', widgets.preview)
vim.keymap.set('n', '<Leader>df', helpers.centered_float_frames)
vim.keymap.set('n', '<Leader>ds', helpers.centered_float_scopes)

keymapper.nnoremap('<F7>', ':DapTerminate<CR>')

vim.fn.sign_define('DapBreakpoint', { text = ' ', texthl = '', linehl = '', numhl = '' })
