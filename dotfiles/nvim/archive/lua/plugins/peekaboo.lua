return {
    'junegunn/vim-peekaboo',
    event = 'VeryLazy',
    config = function()
        vim.cmd('runtime vim/config/peekaboo.vim')
    end
}
