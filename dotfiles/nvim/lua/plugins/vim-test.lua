return {
    'vim-test/vim-test',
    ft = { 'python' },
    config = function()
        vim.cmd('runtime vim/vim-test.vim')
    end,
    dependencies = {
        'jgdavey/tslime.vim',
        config = function()
            vim.cmd('let g:tslime_always_current_session = 1')
        end
    }
}
