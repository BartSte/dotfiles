local helpers = require('helpers-dap')
local dap_python = require('dap-python')

dap_python.setup(helpers.get_debugpy())
dap_python.test_runner = 'pytest'
