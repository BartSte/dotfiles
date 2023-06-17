return {
    'nvim-orgmode/orgmode',
    config = function()
        require('config.orgmode')
    end,
    ft = { 'org' },
    keys = {
        { "<a-r>" },
        { "<space>oa", "<Cmd>lua require('orgmode').action('agenda.prompt')<CR>" }
    },
    dependencies = {
        'BartSte/nvim-khalorg',
        'dhruvasagar/vim-table-mode',
    }
}
