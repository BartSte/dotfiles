local keymapper = require('helpers.keymapper')
local mappings = require('helpers.mappings')

vim.opt_local.breakindent = true
vim.opt_local.concealcursor = "nc"
vim.opt_local.conceallevel = 2
vim.opt_local.expandtab = true
vim.opt_local.formatoptions:append("n")
vim.opt_local.formatoptions:append("q")
vim.opt_local.formatoptions:remove("c")
vim.opt_local.formatoptions:remove("t")
vim.opt_local.linebreak = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.spell = true
vim.opt_local.spelllang = { "en_us" }
vim.opt_local.tabstop = 2
vim.opt_local.textwidth = 9999
vim.opt_local.wrap = true

keymapper.buffer_nnoremap('<leader>f', mappings.gggqG)
keymapper.silent_buffer_nnoremap('<leader>i', ":Org indent_mode<CR>")
keymapper.buffer_nnoremap('<leader>oie', ": lua require('config.fzf').get_email()<CR>")
keymapper.buffer_inoremap(
    '<S-CR>',
    '<cmd>lua require("orgmode").action("org_mappings.meta_return")<CR>',
    { silent = true }
)
