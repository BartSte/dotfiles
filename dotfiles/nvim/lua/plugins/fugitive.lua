return {
    'tpope/vim-fugitive',
    keys = {
        { '<leader>g' }
    },
    config = function()
        vim.cmd('runtime vim/config/fugitive.vim')
    end
}
