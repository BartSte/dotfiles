local keymapper = require('helpers.keymapper')
vim.opt_local.conceallevel = 2
vim.opt_local.spell = true
vim.opt_local.textwidth = 79
vim.opt_local.colorcolumn = '79'
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2

keymapper.nnoremap('<leader>oie', '<cmd>Email<CR>')
