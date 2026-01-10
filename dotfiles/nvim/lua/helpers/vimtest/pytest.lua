local tslime = require('helpers.tslime')

local M = {}

-- Returns the output of `wpy -wpy-path` if it exists, otherwise returns ''.
local function use_wuv()
    return vim.env.WIN_VENV ~= nil and vim.fn.executable('wpy') == 1
end

-- When running WSL and a venv is returned by `wpy -p`, use that venv. If not,
-- return the $VIRTUAL_ENV that corresponds to the OS.
local function make_cmd()
    if use_wuv() then
        return "wuv run --with ipdb pytest "
    else
        return "uv run --with ipdb pytest "
    end
end

-- Replace the first occurence of `pattern` in `cmd` with `replacement`. If
-- `replacement` is '' or nil, return `cmd` unchanged.
local function replace(cmd, pattern, replacement)
    if replacement == '' or replacement == nil then
        return cmd
    else
        return string.gsub(cmd, pattern, replacement, 1)
    end
end

local default_opts = {
    prefix = 'tmux clearhist; clear;',
    args = '-s -rA',
    loglevel = 'INFO',
}

-- Test strategy that can run tests for Linux projects and Windows projects
-- that are edited from WSL. `args` is a string of additional arguments to pass
-- to pytest. `command` will be runned before the test command. For example, if
-- you want to clear the screen before running the tests, you can pass `clear;`
-- as command.
M.make_strategy = function(opts)
    opts = vim.tbl_deep_extend('force', default_opts, opts or {})
    return function(cmd)
        if vim.fn.has('win32') == 1 then
            vim.notify('pytest.lua is not supported on Windows. Use WSL instead.', vim.log.levels.WARN)
        else
            local args = opts.args .. ' --log-level=' .. opts.loglevel

            cmd = replace(cmd, "^python[^ ]+", make_cmd())
            cmd = replace(cmd, "uv run pytest", make_cmd())
            cmd = opts.prefix .. ' ' .. cmd .. ' ' .. args

            tslime.send_to_tmux(cmd .. '\n')
        end
    end
end

return M
