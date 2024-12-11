return {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "jay-babu/mason-null-ls.nvim",
    },
    config = function()
        -- For mason-null-ls to work, mason and null-ls must be setup first. In
        -- contrast to mason-lspconfig, which has antoher order.
        require("mason").setup()
        require("config.null-ls")
        require("mason-null-ls").setup({
            -- Custom formatters so they are not picked up by mason-null-ls
            ensure_installed = { "autopep8", "autoflake", "shellcheck" },
        })
    end
}
