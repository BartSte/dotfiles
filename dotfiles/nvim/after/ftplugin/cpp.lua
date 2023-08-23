local keymapper = require('helpers.keymapper')

--TODO: added the following using tslime:- 
-- - When hitting F5, lldb is launched in tmux window 1
-- - When hitting F9, a breakpoint is send to lldb while it is running

vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2

keymapper.buffer_nnoremap('gs', '<cmd>ClangdSwitchSourceHeader<cr>')
keymapper.buffer_nnoremap('gS', '<cmd>wincmd v<cr><cmd>ClangdSwitchSourceHeader<cr>')
keymapper.buffer_nnoremap('<leader>gs', '<cmd>wincmd o<cr><cmd>wincmd v<cr><cmd>ClangdSwitchSourceHeader<cr>')
keymapper.buffer_nnoremap('<a-t>', ':GTestRunUnderCursor<CR>')
