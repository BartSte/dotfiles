local hop = require('hop')
local hint = require('hop.hint')
local jump_target = require('hop.jump_target')


require'hop'.setup {
    keys = '/bcmkpqtvzxyowurigh;asldefn',
    jump_on_sole_occurrence = true,
    uppercase_labels = true,
    multi_windows = false,
}

vim.api.nvim_set_keymap('n', '<leader>t', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, hint_offset = -1 })<cr>", {})
vim.api.nvim_set_keymap('n', '<leader>T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, hint_offset = 1 })<cr>", {})
vim.api.nvim_set_keymap('n', '<leader>d', "<cmd>lua require'hop'.hint_lines({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR})<cr>", {})
vim.api.nvim_set_keymap('n', '<leader>u', "<cmd>lua require'hop'.hint_lines({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR})<cr>", {})
vim.api.nvim_set_keymap('n', '<leader>w', "<cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR})<cr>", {})
vim.api.nvim_set_keymap('n', '<leader>e', "<cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, hint_position = require'hop.hint'.HintPosition.END})<cr>", {})
vim.api.nvim_set_keymap('n', '<leader>b', "<cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR})<cr>", {})
vim.api.nvim_set_keymap('n', '<leader>ge', "<cmd>lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, hint_position = require'hop.hint'.HintPosition.END})<cr>", {})


vim.keymap.set('n', '<leader>f',
function ()
    local opts = {direction = hint.HintDirection.AFTER_CURSOR}
    hop.hint_char1(opts)
end)

vim.keymap.set('n', '<leader>F',
function ()
    local opts = {direction = hint.HintDirection.BEFORE_CURSOR}
    hop.hint_char1(opts)
end)

vim.keymap.set('n', '<leader>w',
function ()
    local opts = {direction = hint.HintDirection.AFTER_CURSOR}
    hop.hint_words(opts)
end)

vim.keymap.set('n', '<leader>W',
function ()
    local opts = hop.opts
    local regex = "[ |\t][^ \t]"
    local generator = jump_target.jump_targets_by_scanning_lines
    local hints = generator(jump_target.regex_by_searching(regex))

    opts.direction = hint.HintDirection.AFTER_CURSOR
    hop.hint_with(hints, opts)
end)
