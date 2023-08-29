M = {
    vimtest = {
        loglevel = 'INFO',
        python = {
            args = '-s -rA',
            strategy = nil,
            wslwinvenvs = vim.fn.expand('$WH/venvs/'),
            make_strategy = nil,
            strategy_debug = nil,
        }
    }
}

-- When running WSL and a venv is present in g:wsl_win_venvs, it will take
-- presedence over $VIRTUAL_ENV.
local function get_venv()
    local directory = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
    local wsl_win_venv = M.vimtest.python.wslwinvenvs .. directory
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
    local result = ''

    if venv == '' then
        result = cmd
    elseif vim.fn.has('win32') == 1 then
        result = venv .. '\\Scripts\\' .. cmd
    elseif venv == vim.env.VIRTUAL_ENV then
        result = venv .. '/bin/' .. cmd
    else
        local python_exe_cmd = string.gsub(cmd, '^python[^ ]+ ', 'python.exe ')
        result = venv .. '/Scripts/' .. python_exe_cmd
    end

    return result .. ' ' .. M.vimtest.python.args .. ' --log-level=' .. M.vimtest.loglevel
end

-- Sends a command to tmux. It ensures that the command line is reset by
-- sending C-c before the command.
local function send_to_tmux(cmd)
    vim.api.nvim_call_function('Send_to_Tmux', {'C-c'})
    vim.api.nvim_call_function('Send_to_Tmux', {cmd})
end

-- Test strategy that can run tests for Linux projects and Windows projects
-- that are edited from WSL. `args` is a string of additional arguments to pass
-- to pytest.
-- `command` will be runned before the test command. For example, if you want
-- to clear the screen before running the tests, you can pass `clear;` as
-- command.
local function make_strategy(args, prefix)
    args = args or ''
    prefix = prefix or ''
    return function(cmd)
        local venv = get_venv()
        local full_cmd = prefix .. get_command(venv, cmd)
        send_to_tmux(full_cmd .. ' ' .. args .. '\n')
    end
end

M.vimtest.python.strategy = make_strategy('', 'tmux clearhist;')
M.vimtest.python.make_strategy = make_strategy
M.vimtest.python.strategy_debug = make_strategy('--pdb --pdbcls=IPython.terminal.debugger:Pdb', 'tmux clearhist;')

return M
