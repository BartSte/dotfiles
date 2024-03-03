local M = {}

M.setup = function()
    vim.g.auto_save = 1
    vim.g.auto_save_silent = 1
    vim.g.auto_save_events = { "InsertLeave", "CursorHold" }
end

return M
