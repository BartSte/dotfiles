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
        require("mason").setup()
        require("mason-lspconfig").setup({ automatic_installation = true })
        require("config.lsp")
    end
}
