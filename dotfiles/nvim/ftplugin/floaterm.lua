keymapper = require("keymapper")

keymapper.buffer_nnoremap('<C-n>', '<cmd>bnext<CR>')
keymapper.buffer_nnoremap('<C-p>', '<cmd>bprevious<CR>')
keymapper.buffer_tnoremap('<c-n>', '<C-\\><C-n>:FloatermNext<CR>')
keymapper.buffer_tnoremap('<c-p>', '<C-\\><C-n>:FloatermPrev<CR>')
