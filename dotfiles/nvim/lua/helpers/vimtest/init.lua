local pytest = require('helpers.vimtest.pytest')

local M = {}

local default_opts = {
    pytest = {
        loglevel = 'INFO',
        wslwinvenvs = vim.fn.expand('$WH/venvs/'), -- FIX: not a good default
        test = {
            prefix = 'tmux clearhist; clear;',
            args = '-s -rA',
        },
        debug = {
            prefix = 'tmux clearhist; clear;',
            args = '-s -rA --pdb --pdbcls=IPython.terminal.debugger:Pdb',
        }
    }
}

M.setup = function(opts)
    opts = vim.tbl_deep_extend('force', default_opts, opts or {})

    local pytest_opts = {
        loglevel = opts.pytest.loglevel,
        wslwinvenvs = opts.pytest.wslwinvenvs,
        prefix = opts.pytest.test.prefix,
        args = opts.pytest.test.args,
    }

    local pytest_opts_debug = {
        loglevel = opts.pytest.loglevel,
        wslwinvenvs = opts.pytest.wslwinvenvs,
        prefix = opts.pytest.debug.prefix,
        args = opts.pytest.debug.args,
    }

    M.pytest = {
        strategy = pytest.make_strategy(pytest_opts),
        strategy_debug = pytest.make_strategy(pytest_opts_debug)
    }
end

return M
