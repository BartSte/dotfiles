vim.g.copilot_filetypes = { oil = false }

vim.keymap.set('i', '<Right>', 'copilot#Accept("<Right>")', {
    expr = true,
    replace_keycodes = false
})
vim.keymap.set('i', '<C-Right>', 'copilot#AcceptWord("<C-Right>")', {
    expr = true,
    replace_keycodes = false
})
vim.keymap.set('i', '<S-Right>', 'copilot#AcceptLine("<S-Right>")', {
    expr = true,
    replace_keycodes = false
})
vim.keymap.set('i', '<Left>', 'copilot#Dismiss("<Left>")', {
    expr = true,
    replace_keycodes = false
})
vim.keymap.set('n', '<leader>co', ':Copilot enable<CR>', {
    noremap = true
})
vim.keymap.set('i', '<C-n>', 'copilot#Next("<C-n>")', {
    expr = true,
    replace_keycodes = false
})
vim.keymap.set('i', '<C-p>', 'copilot#Prev("<C-p>")', {
    expr = true,
    replace_keycodes = false
})
vim.g.copilot_no_tab_map = true
