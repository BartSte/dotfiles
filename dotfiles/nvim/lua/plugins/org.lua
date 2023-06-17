return {
    {
        'nvim-orgmode/orgmode',
        config = function()
            require('config.orgmode')
        end,
        ft = { 'org' },
        keys = {
            { "<a-r>" },
            { "<space>oa", "<Cmd>lua require('orgmode').action('agenda.prompt')<CR>" }
        }
    },
    {
        'BartSte/nvim-khalorg',
        lazy = true,
        dependencies = {
            'nvim-orgmode/orgmode'
        },
    },
    'dhruvasagar/vim-table-mode',
}
