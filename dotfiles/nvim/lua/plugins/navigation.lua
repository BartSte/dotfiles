return {
    'moll/vim-bbye',
    'BartSte/hop.nvim',
    {
        'junegunn/fzf.vim',
        keys = {
            { '<a-o>' },
            { '<a-v>' },
            { '<a-r>' },
            { '<a-c>' },
            { '<a-A>' }
        },
        cmd = { 'Ag' },
        config = function()
            vim.cmd('runtime vim/fzf.vim')
        end,
        dependencies = {
            { 'junegunn/fzf', build = ':call fzf#install()' },
        }
    },
    {
        'stevearc/oil.nvim',
        event = 'TermOpen', -- when fzf is triggered
        keys = {
            { '<a-x>' },
            { '<a-X>' }
        },
        config = function()
            require('config.oil')
        end
    }
}
