return {
    'nvim-orgmode/orgmode',
    config = function()
        require('config.orgmode')
    end,
    ft = { 'org' },
    keys = {
        { "<a-r>" },
        { "<space>oa", "<Cmd>lua require('orgmode').action('agenda.prompt')<CR>" },
        { "<space>oc", "<Cmd>lua require('orgmode').action('capture.prompt')<CR>" },
    },
    cond = function() return vim.fn.has('linux') == 1 end,
    dependencies = {
        {
            'BartSte/nvim-khalorg',
            -- dir = "~/code/nvim-khalorg"
        },
        'dhruvasagar/vim-table-mode',
    }
}
