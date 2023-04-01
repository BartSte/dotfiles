local os_path = require('os_path')
local widgets = require('dap.ui.widgets')

local M = {}

M.get_debugpy = function()
    if vim.fn.has("win32") == 1 then
        --for windows, use debugpy for the global python installation to avoid cmd.exe popups
        return vim.g.python3_host_prog
    else
        -- For linux use the mason packages
        local base = os_path.path_join(vim.fn.stdpath('data'), 'mason', 'packages', 'debugpy', 'venv')
        return os_path.path_join(base, 'bin', 'python')
    end
end

M.centered_float_frames = function() widgets.centered_float(widgets.frames) end
M.centered_float_scopes = function() widgets.centered_float(widgets.scopes) end

return M
