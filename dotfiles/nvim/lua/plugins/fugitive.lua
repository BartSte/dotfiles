return {
    'tpope/vim-fugitive',
    keys = {
        { '<a-g>', ':G ' },
        { '<a-G>', ':vertical G<CR>' },
        { '<a-d>', ':silent! normal gf<CR>:wincmd o<bar>Gvdiffsplit<CR>' }
    },
    config = function()
        vim.cmd('runtime vim/config/fugitive.vim')
    end
}
