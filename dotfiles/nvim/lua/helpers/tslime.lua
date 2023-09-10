local M = {}

-- Sends a command to tmux. It ensures that the command line is reset by
-- sending C-c before the command.
M.send_to_tmux = function(cmd)
    vim.api.nvim_call_function('Send_to_Tmux', {'C-c'})
    vim.api.nvim_call_function('Send_to_Tmux', {cmd})
end

return M

