return { {
    "folke/neodev.nvim",
    ft = "lua",
    config = function() require("config-neodev") end
},
    'neovim/nvim-lspconfig',
    'jose-elias-alvarez/null-ls.nvim',
}
