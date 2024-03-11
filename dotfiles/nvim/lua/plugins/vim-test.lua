return {
    'vim-test/vim-test',
    ft = { 'python' },
    config = function()
        vim.cmd('runtime vim/config/vim-test.vim')
    end,
    dependencies = {
        'jgdavey/tslime.vim',
        config = function()
            vim.cmd('runtime vim/config/tslime.vim')
        end
    }
}
