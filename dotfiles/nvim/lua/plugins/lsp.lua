return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
        -- For mason-lspconfig to work, mason and mason-lspconfig need to be
        -- setup first. In contrast to mason-null-ls, which has another order.
        require("config.mason")
        require("config.mason-lspconfig")
        require("config.lsp")
    end
}
