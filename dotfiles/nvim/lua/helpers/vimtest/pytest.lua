local tslime = require('helpers.tslime')

local M = {}


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
        elseif vim.fn.executable('wuv') == 0 then
            vim.notify('wuv is not installed. Please install wuv from the wslpy project.', vim.log.levels.WARN)
        else
            local wuv = "wuv --wuv-fallback run --with ipdb pytest "
            local args = opts.args .. ' --log-level=' .. opts.loglevel

            cmd = string.gsub(cmd, "^python[^ ]*", wuv)
            cmd = string.gsub(cmd, "^uv run pytest", wuv)
            cmd = string.format("%s %s %s", opts.prefix, cmd, args)

            tslime.send_to_tmux(cmd .. '\n')
        end
    end
end

return M
