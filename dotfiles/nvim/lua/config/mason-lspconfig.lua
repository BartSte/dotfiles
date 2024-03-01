local M = {}

local opts = { automatic_installation = true }

M.setup = function()
    require("mason-lspconfig").setup(opts)
end

return M
