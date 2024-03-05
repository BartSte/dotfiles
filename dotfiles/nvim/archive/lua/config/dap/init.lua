local dap = require('dap')
local path = require('helpers.os_path')
local vscode = require('dap.ext.vscode')
local my_launch = path.path_join(path.home(), 'dotfiles/launch.json')

dap.defaults.fallback.terminal_win_cmd = '80vsplit new'
dap.defaults.fallback.focus_terminal = false

vscode.load_launchjs('.vscode/launch.json')
vscode.load_launchjs(my_launch)
vim.fn.sign_define('DapBreakpoint', { text = ' ', texthl = '', linehl = '', numhl = '' })

require('config.dap.python')
require('config.dap.cpp')
require('config.dap.mappings')

-- Reload buffers to apply ftplugin configurations
vim.cmd('doautocmd BufRead')
