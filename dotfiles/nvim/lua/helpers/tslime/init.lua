local pytest = require('helpers.tslime.pytest')

local M = {}

M.vimtest = {
    pytest = {
        strategy = nil,
        strategy_debug = nil,
    }
}

local default_opts = {
    vimtest = {
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
}

M.setup = function(opts)
    opts = vim.tbl_deep_extend('force', default_opts, opts or {})

    local pytest_opts = {
        loglevel = opts.vimtest.pytest.loglevel,
        wslwinvenvs = opts.vimtest.pytest.wslwinvenvs,
        prefix = opts.vimtest.pytest.test.prefix,
        args = opts.vimtest.pytest.test.args,
    }

    local pytest_opts_debug = {
        loglevel = opts.vimtest.pytest.loglevel,
        wslwinvenvs = opts.vimtest.pytest.wslwinvenvs,
        prefix = opts.vimtest.pytest.debug.prefix,
        args = opts.vimtest.pytest.debug.args,
    }

    M.vimtest.pytest.strategy = pytest.make_strategy(pytest_opts)
    M.vimtest.pytest.strategy_debug = pytest.make_strategy(pytest_opts_debug)

    return M
end

return M
