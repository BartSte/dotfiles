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
        require("config.mason").setup()
        require("config.null-ls").setup()
        require("config.mason-null-ls").setup()
    end
}
