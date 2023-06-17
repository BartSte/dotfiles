return {
    'vim-test/vim-test',
    'jgdavey/tslime.vim',
    {
        'mfussenegger/nvim-dap',
    },
    {
        'mfussenegger/nvim-dap-python',
        lazy = true,
        config = function() require('config.dap') end,
        dependencies = {
            'mfussenegger/nvim-dap',
        }
    },
    {
        'theHamsta/nvim-dap-virtual-text',
        lazy = true,
        config = function() require('config.dap-virtual-text') end,
        dependencies = {
            'mfussenegger/nvim-dap'
        }
    },
}
