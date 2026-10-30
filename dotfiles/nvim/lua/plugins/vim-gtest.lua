return {
    'alepez/vim-gtest',
    ft = { 'cpp', 'c', 'objc', 'objc++' },
    config = function()
        vim.cmd('runtime vim/config/vim-gtest.vim')
        require("projectrc").require("config.vim-gtest")
    end,
}
