local keymapper = require('keymapper')

vim.opt_local.conceallevel = 2

keymapper.nnoremap('<leader>r', ':silent !mycalsync &<CR>')
