vim.cmd('runtime! vim/before/*.vim')

require('helpers.lazy').bootstrap()
require('lazy').setup('plugins', {  change_detection = { enabled = false }})
require("config")

vim.cmd('runtime! vim/after/*')
