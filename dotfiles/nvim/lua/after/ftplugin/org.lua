local keymapper = require('helpers.keymapper')

vim.opt_local.spell = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.textwidth = 0
vim.opt_local.colorcolumn = '100'
vim.opt_local.wrap = true

keymapper.nnoremap('<leader>oie', ": lua require('config.fzf').get_email()<CR>")
