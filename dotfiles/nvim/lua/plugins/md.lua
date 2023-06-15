return {
    {
        "iamcco/markdown-preview.nvim",
        ft = 'markdown',
        build = function() vim.fn["mkdp#util#install"]() end,
        config = function() vim.cmd("so ~/dotfiles/nvim/vim/config-markdown.vim") end
    }
}
