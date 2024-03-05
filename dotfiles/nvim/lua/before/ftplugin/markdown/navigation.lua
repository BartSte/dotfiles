local M = {}

M.setup = function()
    vim.opt_local.spell = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.textwidth = 100
    vim.opt_local.colorcolumn = "100"
end

return M
