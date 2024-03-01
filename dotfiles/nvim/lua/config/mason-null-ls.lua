local M = {}

local opts = {
    ensure_installed = {
        "autoflake",
        "autopep8",
        "isort",
        "pylint",
        "cmakelang",
        "shfmt",
        "prettier",
        "markdownlint",
    },
    -- automatic_installation = true
}

M.setup = function()
    require("mason-null-ls").setup(opts)
end

return M
