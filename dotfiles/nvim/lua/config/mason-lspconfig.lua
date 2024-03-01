local M = {}

local opts = {
    ensure_installed = {
        "pyright",
        "clangd",
        "cmake",
        "vimls",
        "lua_ls",
        "bashls",
        "jsonls",
        "marksman"
    }
}

M.setup = function()
    require("mason-lspconfig").setup(opts)
end

return M
