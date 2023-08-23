return {
    "folke/neodev.nvim",
    ft = 'lua',
    event = { "BufReadPost", "BufNewFile" },
    config = function() require("config.neodev") end,
    dependencies = { 'neovim/nvim-lspconfig' }
}
