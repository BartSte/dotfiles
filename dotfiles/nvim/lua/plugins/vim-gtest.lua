return {
    'alepez/vim-gtest',
    ft = { 'cpp', 'c', 'objc', 'objc++' },
    config = function()
        require("projectrc").require("config.vim-gtest")
    end,
    dependencies = {
        'jgdavey/tslime.vim',
        config = function()
            vim.cmd('runtime vim/config/tslime.vim')
        end
    }
}
