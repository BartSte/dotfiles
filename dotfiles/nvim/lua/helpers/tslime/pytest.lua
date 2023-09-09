local send = require('helpers.tslime.send')

local M = {}

-- When running WSL and a venv is present in g:wsl_win_venvs, it will take
-- presedence over $VIRTUAL_ENV.
local function get_venv(wsl_win_venvs)
    local directory = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
    local wsl_win_venv = wsl_win_venvs .. directory
    if vim.fn.isdirectory(wsl_win_venv) == 1 then
        return wsl_win_venv
    elseif vim.env.VIRTUAL_ENV ~= nil then
        return vim.env.VIRTUAL_ENV
    else
        return ''
    end
end

-- Retruns the test command that corresponds to the WSL, WSL+windows, or linux
-- venv.
local function get_command(venv, cmd)
    if venv == '' then
        return cmd
    elseif vim.fn.has('win32') == 1 then
        return venv .. '\\Scripts\\' .. cmd
    elseif venv == vim.env.VIRTUAL_ENV then
        return venv .. '/bin/' .. cmd
    else
        local python_exe_cmd = string.gsub(cmd, '^python[^ ]+ ', 'python.exe ')
        return venv .. '/Scripts/' .. python_exe_cmd
    end
end

local default_opts = {
    args = '-s -rA',
    prefix = '',
    loglevel = 'INFO',
    wslwinvenvs = '',
}

-- Test strategy that can run tests for Linux projects and Windows projects
-- that are edited from WSL. `args` is a string of additional arguments to pass
-- to pytest.
-- `command` will be runned before the test command. For example, if you want
-- to clear the screen before running the tests, you can pass `clear;` as
-- command.
M.make_strategy = function(opts)
    opts = vim.tbl_deep_extend('force', default_opts, opts or {})
    return function(cmd)
        local venv = get_venv(opts.wslwinvenvs)
        local full_cmd = opts.prefix .. get_command(venv, cmd)
        local args = opts.args .. ' --log-level=' .. opts.loglevel
        send.to_tmux(full_cmd .. ' ' .. args .. '\n')
    end
end

return M
