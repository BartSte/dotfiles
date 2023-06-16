return {
    {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },
    'nvim-lualine/lualine.nvim',
    { 'luisiacc/gruvbox-baby', branch = 'main' },
}
