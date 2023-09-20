vim.opt_local.spell = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.textwidth = 0
vim.opt_local.colorcolumn = ''
vim.opt_local.conceallevel = 2

require('helpers.keymapper').nnoremap('<leader>oie', '<cmd>Email<CR>')
