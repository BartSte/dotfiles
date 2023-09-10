local tslime = require('helpers.tslime')

local M = {}

-- Returns the output of `wpy -p` if it exists, otherwise returns ''.
local function wsl_win_py()
    if vim.fn.executable('wpy') == 1 then
        local stdout = vim.fn.system('wpy -p')
        return string.gsub(stdout, '\n$', '') -- Remove trailing newline
    else
        return ''
    end
end

-- Returns the path to the python executable in the Windows venv.
local function win_py()
    return vim.env.VIRTUAL_ENV .. '\\Scripts\\python.exe'
end

-- Returns the path to the python executable in the Linux venv.
local function linux_py()
    return vim.env.VIRTUAL_ENV .. '/bin/python'
end

-- When running WSL and a venv is returned by `wpy -p`, use that venv. If not,
-- return the $VIRTUAL_ENV that corresponds to the OS.
local function get_py()
    local wsl_win_venv = wsl_win_py()
    if wsl_win_venv ~= '' then
        return wsl_win_venv
    elseif vim.env.VIRTUAL_ENV == nil then
        return ''
    elseif vim.fn.has('win32') == 1 then
        return win_py()
    else
        return linux_py()
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
    wslwinvenvs = '',
}

-- Test strategy that can run tests for Linux projects and Windows projects
-- that are edited from WSL. `args` is a string of additional arguments to pass
-- to pytest. `command` will be runned before the test command. For example, if
-- you want to clear the screen before running the tests, you can pass `clear;`
-- as command.
M.make_strategy = function(opts)
    opts = vim.tbl_deep_extend('force', default_opts, opts or {})
    return function(cmd)
        local args = opts.args .. ' --log-level=' .. opts.loglevel

        cmd = replace(cmd, "^python[^ ]+", get_py())
        cmd = opts.prefix .. ' ' .. cmd .. ' ' .. args

        tslime.send_to_tmux(cmd .. '\n')
    end
end

return M
