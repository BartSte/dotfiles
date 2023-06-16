return {
    'vim-test/vim-test',
    'jgdavey/tslime.vim',
    {
        'mfussenegger/nvim-dap',
        lazy = true,
    },
    {
        'mfussenegger/nvim-dap-python',
        lazy = true,
        config = function() require('config.nvim-dap') end
    },
    'jay-babu/mason-nvim-dap.nvim',
    {
        'theHamsta/nvim-dap-virtual-text',
        lazy = true,
        config = function() require('config.nvim-dap-virtual-text') end
    },
}
