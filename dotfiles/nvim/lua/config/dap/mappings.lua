local dap = require('dap')
local helpers = require('helpers.dap')
local widgets = require('dap.ui.widgets')
local keymapper = require('helpers.keymapper')

vim.keymap.set('n', '<F4>', dap.run_last)
vim.keymap.set('n', '<F5>', dap.continue)
vim.keymap.set('n', '<F9>', dap.toggle_breakpoint)
vim.keymap.set('n', '<F10>', dap.step_over)
vim.keymap.set('n', '<F11>', dap.step_into)
vim.keymap.set('n', '<F12>', dap.step_out)
vim.keymap.set('n', '<a-R>', dap.repl.open)
vim.keymap.set({ 'n', 'v' }, '<Leader>de', widgets.hover)
vim.keymap.set({ 'n', 'v' }, '<Leader>dp', widgets.preview)
vim.keymap.set('n', '<Leader>ds', helpers.centered_float_frames)
vim.keymap.set('n', '<Leader>dv', helpers.centered_float_scopes)

keymapper.nnoremap('<F7>', ':DapTerminate<CR>')

