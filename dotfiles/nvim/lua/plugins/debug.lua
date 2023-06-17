return {
    {
        'vim-test/vim-test',
        keys = {
            { '<a-t>', ':TestNearest<CR>' },
            { '<a-l>', ':TestLast<CR>' },
            { '<a-f>', ':TestFile<CR>' },
        },
        config = function()
            vim.cmd('runtime vim/vim-test.vim')
        end
    },
    'jgdavey/tslime.vim',
    {
        'mfussenegger/nvim-dap',
    },
    {
        'mfussenegger/nvim-dap-python',
        lazy = true,
        keys = { '<F5>', '<cmd>DapContinue<CR>' },
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
