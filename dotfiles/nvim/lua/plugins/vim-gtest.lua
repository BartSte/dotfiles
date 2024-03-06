return {
    'alepez/vim-gtest',
    ft = { 'cpp', 'c', 'objc', 'objc++' },
    config = function()
        require("helpers.projectrc").require("config.vim-gtest")
    end,
    dependencies = {
        'jgdavey/tslime.vim',
        config = function()
            vim.cmd('runtime vim/tslime.vim')
        end
    }
}
