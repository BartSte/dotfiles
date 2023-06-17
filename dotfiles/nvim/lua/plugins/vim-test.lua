return {
    'vim-test/vim-test',
    keys = {
        { '<a-t>', ':TestNearest<CR>' },
        { '<a-l>', ':TestLast<CR>' },
        { '<a-f>', ':TestFile<CR>' },
    },
    config = function()
        vim.cmd('runtime vim/vim-test.vim')
    end,
    dependencies = {
        'jgdavey/tslime.vim',
    }
}
