local M = {}

M.setup = function()
    if vim.fn.has('linux') == 1 then
        vim.g.python3_host_prog = '/usr/bin/python3'
    end
end

return M
