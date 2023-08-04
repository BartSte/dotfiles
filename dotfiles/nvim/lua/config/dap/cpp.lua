local dap = require('dap')
local path = require('helpers.os_path')
local vscode = require('dap.ext.vscode')
local helpers = require('helpers.dap')
local widgets = require('dap.ui.widgets')
local keymapper = require('helpers.keymapper')
local my_launch = path.path_join(path.get_home(), 'dotfiles/launch.json')

dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = '/home/barts/.local/share/nvim/mason/bin/OpenDebugAD7',
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = false,
  },
  {
    name = "Launch file with args",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    args = function()
      local args = vim.fn.input('Arguments: ')
      if args ~= '' then
        return vim.split(args, ' ', true)
      else
        return nil
      end
    end,
    stopAtEntry = false,
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'cppdbg',
    request = 'launch',
    MIMode = 'gdb',
    miDebuggerServerAddress = 'localhost:1234',
    miDebuggerPath = '/usr/bin/gdb',
    cwd = '${workspaceFolder}',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
  },
}
