return {
    {
        'moll/vim-bbye',
        keys = {
            { '<space>q', '<cmd>Bdelete<cr>' }
        },
    },
    {
        'BartSte/hop.nvim',
        keys = { { 'j' }, { 'l' }, { 'k' }, { 'h' }, { 'J' }, { 'L' }, { 'K' }, { 'H' } },
        config = function()
            require('config.hop')
        end
    },
    {
        'junegunn/fzf.vim',
        keys = {
            { '<a-o>' },
            { '<a-v>' },
            { '<a-r>' },
            { '<a-c>' },
            { '<a-h>' },
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
        config = function()
            require('config.oil')
        end
    }
}
