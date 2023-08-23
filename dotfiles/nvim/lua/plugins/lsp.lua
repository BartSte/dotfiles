return {
    'neovim/nvim-lspconfig',
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("config.lsp")
    end,
    dependencies = {
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
        "williamboman/mason.nvim",
        {
            "williamboman/mason-lspconfig.nvim",
            config = function()
                require("mason-lspconfig").setup({
                    automatic_installation = true,
                })
            end
        },
    }
    ,
}
