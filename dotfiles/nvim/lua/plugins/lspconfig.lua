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
        require("config.mason").setup()
        require("config.mason-lspconfig").setup()
        require("config.lsp") -- TODO: add setup function
    end
}

