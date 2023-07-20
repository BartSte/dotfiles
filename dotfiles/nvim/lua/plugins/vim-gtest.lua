return {
    'BartSte/vim-gtest',
    ft = { 'cpp', 'c', 'objc', 'objc++' },
    config = function()
        require('config.vim-gtest').setup()
    end,
    dependencies = {
        'jgdavey/tslime.vim',
        config = function()
            vim.cmd('let g:tslime_always_current_session = 1')
        end
    }
}
