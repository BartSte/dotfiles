local helpers = require('helpers.oil')
local keymapper = require('helpers.keymapper')
vim.b.auto_save = 0
vim.opt_local.colorcolumn = '79'
vim.opt_local.textwidth = 79

keymapper.buffer_noremap("<leader>r", helpers.rename)
