return {
    {
        'stsewd/fzf-checkout.vim',
        keys = {
            { '<a-B>' },
        },
        dependencies = {
            { 'junegunn/fzf.vim' }
        }
    },
    {
        'junegunn/fzf.vim',
        keys = {
            { '<a-o>' },
            { '<a-v>' },
            { '<a-r>' },
            { '<a-c>' },
            { '<a-h>' },
            { '<a-a>' }
        },
        cmd = { 'Ag' },
        config = function()
            vim.cmd('runtime vim/fzf.vim')
        end,
        dependencies = {
            { 'junegunn/fzf', build = ':call fzf#install()' },
        }
    }
}
