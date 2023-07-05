return {
    'junegunn/fzf.vim',
    keys = {
        { '<a-o>' },
        { '<a-v>' },
        { '<a-r>' },
        { '<a-c>' },
        { '<a-h>' },
        { '<a-a>' },
        { '<a-B>' },
    },
    cmd = { 'Ag' },
    config = function()
        vim.cmd('runtime vim/fzf.vim')
    end,
    dependencies = {
        { 'stsewd/fzf-checkout.vim' },
        { 'junegunn/fzf',           build = ':call fzf#install()' },
    }
}
