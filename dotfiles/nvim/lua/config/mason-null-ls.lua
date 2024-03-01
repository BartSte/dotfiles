local M = {}

local opts = { automatic_installation = true }

M.setup = function()
    require("mason-null-ls").setup(opts)
end

return M
