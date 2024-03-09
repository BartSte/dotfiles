return {
    'tpope/vim-obsession',
    lazy = false,
    config = function()
        vim.cmd('runtime vim/config/obsession.vim')
    end
}
