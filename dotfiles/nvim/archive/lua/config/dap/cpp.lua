local dap = require('dap')
local path = require('helpers.os_path')
local vscode = require('dap.ext.vscode')
local helpers = require('helpers.dap')
local widgets = require('dap.ui.widgets')
local keymapper = require('helpers.keymapper')
local my_launch = path.path_join(path.home(), 'dotfiles/launch.json')

dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
  name = 'lldb'
}

dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
  {
    name = 'Launch with args',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = function()
      local args = vim.fn.input('Arguments: ')
      if args ~= '' then
        return vim.split(args, ' ', true)
      else
        return nil
      end
    end,
  },
}
