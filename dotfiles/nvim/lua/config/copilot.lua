local keymapper = require("helpers.keymapper")

vim.g.copilot_no_tab_map = true
vim.g.copilot_filetypes = { oil = false }

keymapper.expr_inoremap("<Right>", 'copilot#Accept("<Right>")')
keymapper.expr_inoremap("<C-Right>", 'copilot#AcceptWord("<C-Right>")')
keymapper.expr_inoremap("<S-Right>", 'copilot#AcceptLine("<S-Right>")')
keymapper.expr_inoremap("<Left>", 'copilot#Dismiss("<Left>")')
keymapper.expr_nnoremap("<leader>co", ':Copilot enable<CR>')
keymapper.expr_inoremap("<C-n>", 'copilot#Next("<C-n>")')
keymapper.expr_inoremap("<C-p>", 'copilot#Prev("<C-p>")')
