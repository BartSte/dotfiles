return {
    "iamcco/markdown-preview.nvim",
    ft = 'markdown',
    config = function ()
        vim.cmd('runtime vim/config/markdown.vim')
    end,
    build = function()
        vim.fn["mkdp#util#install"]()
    end,
    dependencies = {
        'dhruvasagar/vim-table-mode',
    }
}
