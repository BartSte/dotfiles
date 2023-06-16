require('helpers.lazy').bootstrap()
require('lazy').setup('plugins', {  change_detection = { enabled = false }})
require("config")

require('local-shada')
require('global-marks')

vim.cmd('runtime! vim/*.vim')
