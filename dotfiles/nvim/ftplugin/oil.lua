local keymapper = require('keymapper')
local helpers = require('helpers-oil')
vim.b.auto_save = 0

keymapper.buffer_noremap('<leader>r', helpers.rename)
