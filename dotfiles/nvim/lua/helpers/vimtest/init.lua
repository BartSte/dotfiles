local pytest = require('helpers.vimtest.pytest')

local M = {}

local default_opts = {
    pytest = {
        test = {
            loglevel = 'INFO',
            prefix = 'tmux clearhist; clear;',
            args = '-s -rA',
        },
        debug = {
            loglevel = 'DEBUG',
            prefix = 'tmux clearhist; clear;',
            args = '-s -rA --pdb --pdbcls=IPython.terminal.debugger:Pdb',
        }
    }
}

M.setup = function(opts)
    opts = vim.tbl_deep_extend('force', default_opts, opts or {})

    local test = opts.pytest.test
    local debug = opts.pytest.debug

    local pytest_opts = {
        loglevel = test.loglevel,
        prefix = test.prefix,
        args = test.args,
    }
    local pytest_opts_debug = {
        loglevel = debug.loglevel,
        prefix = debug.prefix,
        args = debug.args,
    }

    M.pytest = {
        strategy = pytest.make_strategy(pytest_opts),
        strategy_debug = pytest.make_strategy(pytest_opts_debug)
    }
end

return M
