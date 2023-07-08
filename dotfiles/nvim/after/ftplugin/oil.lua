local helpers = require('helpers.oil')
local keymapper = require('helpers.keymapper')
vim.b.auto_save = 0

keymapper.buffer_noremap("<leader>r", helpers.rename)
