local keymapper = require('keymapper')

vim.opt_local.conceallevel = 2

keymapper.noremap('<leader>r', ':silent !calsync &<CR>')


