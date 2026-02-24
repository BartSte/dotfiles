local keymapper = require('helpers.keymapper')
local mappings = require("helpers.lsp.mappings")

vim.opt_local.spell = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.textwidth = 0
vim.opt_local.wrap = true

mappings.map_formatter()
keymapper.nnoremap('<leader>oie', ": lua require('config.fzf').get_email()<CR>")
