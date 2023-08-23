local keymapper = require('helpers.keymapper')

vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2

keymapper.buffer_nnoremap('gs', '<cmd>ClangdSwitchSourceHeader<cr>')
keymapper.buffer_nnoremap('gS', '<cmd>wincmd v<cr><cmd>ClangdSwitchSourceHeader<cr>')
keymapper.buffer_nnoremap('<leader>gs', '<cmd>wincmd o<cr><cmd>wincmd v<cr><cmd>ClangdSwitchSourceHeader<cr>')
keymapper.buffer_nnoremap('<a-t>', ':GTestRunUnderCursor<CR>')
