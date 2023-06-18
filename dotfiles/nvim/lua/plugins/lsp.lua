return {
    {
        "folke/neodev.nvim",
        ft = 'lua',
        config = function() require("config.neodev") end,
        dependencies = { 'neovim/nvim-lspconfig' }
    },
    {
        'neovim/nvim-lspconfig',
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("config.lsp-init")
            require("config.lsp-servers")
            require("config.lsp-mappings")
        end,
        dependencies = {
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            "williamboman/mason.nvim",
            {
                "williamboman/mason-lspconfig.nvim",
                config = function()
                    require("mason-lspconfig").setup({ automatic_installation = false })
                end
            },
        }
    },
}
