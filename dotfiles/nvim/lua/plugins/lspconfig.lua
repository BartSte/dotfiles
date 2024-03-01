return {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
        -- For mason-lspconfig to work, mason and mason-lspconfig need to be
        -- setup first. In contrast to mason-null-ls, which has another order.
        require("config.mason").setup()
        require("config.mason-lspconfig").setup()
        require("config.lsp") -- TODO: add setup function
    end
}

