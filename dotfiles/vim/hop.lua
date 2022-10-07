require'hop'.setup {
    keys = '/bcmkpqtvzxyowurigh;asldefn',
    jump_on_sole_occurrence = true,
    uppercase_labels = true,
    multi_windows = false,
}

vim.api.nvim_set_keymap('', '<leader>f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR })<cr>", {})
vim.api.nvim_set_keymap('', '<leader>F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })<cr>", {})
vim.api.nvim_set_keymap('', '<leader>t', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, hint_offset = -1 })<cr>", {})
vim.api.nvim_set_keymap('', '<leader>T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, hint_offset = 1 })<cr>", {})
vim.api.nvim_set_keymap('', '<leader>d', "<cmd>lua require'hop'.hint_lines({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR})<cr>", {})
vim.api.nvim_set_keymap('', '<leader>u', "<cmd>lua require'hop'.hint_lines({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR})<cr>", {})
vim.api.nvim_set_keymap('', '<leader>w', "<cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR})<cr>", {})
vim.api.nvim_set_keymap('', '<leader>e', "<cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, hint_position = require'hop.hint'.HintPosition.END})<cr>", {})
vim.api.nvim_set_keymap('', '<leader>b', "<cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR})<cr>", {})
vim.api.nvim_set_keymap('', '<leader>ge', "<cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, hint_position = require'hop.hint'.HintPosition.END})<cr>", {})

