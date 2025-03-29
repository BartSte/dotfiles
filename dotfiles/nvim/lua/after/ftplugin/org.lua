local keymapper = require('helpers.keymapper')

vim.opt_local.spell = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.textwidth = 100
vim.opt_local.colorcolumn = '100'

keymapper.nnoremap('<leader>oie', ": lua require('config.fzf').get_email()<CR>")
keymapper.nnoremap('<leader>f', ':normal! gg=G<CR><C-o>')
