return {
    'vim-test/vim-test',
    ft = { 'python' },
    config = function()
        vim.cmd('runtime vim/vim-test.vim')
    end,
    dependencies = {
        'jgdavey/tslime.vim',
    }
}
