return {
    "iamcco/markdown-preview.nvim",
    ft = 'markdown',
    config = function ()
        vim.cmd('runtime vim/markdown.vim')
    end,
    dependencies = {
        'dhruvasagar/vim-table-mode',
    }
}
