return {
    { 'junegunn/fzf',     build = ':call fzf#install()' },
    { 'junegunn/fzf.vim', dependencies = { 'junegunn/fzf' } },
    'moll/vim-bbye',
    'BartSte/hop.nvim',
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
