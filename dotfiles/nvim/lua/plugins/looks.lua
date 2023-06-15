return {
    {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function() require("config-treesitter") end
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function() require('config-treesitter-context') end
    },
    'nvim-lualine/lualine.nvim',
    { 'luisiacc/gruvbox-baby', branch = 'main' },
}
