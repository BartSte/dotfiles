require("mason-null-ls").setup({
    -- Custom formatters so they are not picked up by mason-null-ls
    ensure_installed = { "autopep8", "autoflake", "isort" },
})
