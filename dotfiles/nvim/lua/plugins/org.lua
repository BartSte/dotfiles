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
    cond = function() return vim.fn.has('linux') == 1 end,
    dependencies = {
        'junegunn/fzf.vim',
        'BartSte/nvim-khalorg',
        'dhruvasagar/vim-table-mode',
    }
}
