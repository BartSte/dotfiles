local dappy = require('dap-python')
local helpers = require('helpers.dap')

dappy.setup(helpers.get_debugpy())
dappy.test_runner = 'pytest'

vim.opt_local.colorcolumn = '79'
vim.opt_local.textwidth = 79

vim.g.dap_python_loaded = true
