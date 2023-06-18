return {
    'dhruvasagar/vim-table-mode',
    ft = { 'markdown', 'org' },
    config = function()
        vim.cmd('runtime vim/table.vim')
    end
}
