local M = {}

-- Return true if the quickfix window is visible
M.quickfix_visible = function()
    local qf_windows = vim.fn.filter(vim.fn.getwininfo(), "v:val.quickfix")
    return vim.fn.empty(qf_windows) == 0
end

M.toggle_quickfix = function()
    if M.quickfix_visible() then
        vim.cmd("cclose")
    else
        vim.cmd("copen")
    end
end

return M
