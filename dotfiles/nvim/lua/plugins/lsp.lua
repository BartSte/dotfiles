return {
    {
        "folke/neodev.nvim",
        ft = 'lua',
        config = function() require("config.neodev") end
    },
    {
        'neovim/nvim-lspconfig',
        config = function()
            require("config.lsp-init")
            require("config.lsp-servers")
            require("config.lsp-mappings")
        end
    },
    'jose-elias-alvarez/null-ls.nvim',
}
