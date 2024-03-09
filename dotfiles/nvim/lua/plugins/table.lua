return {
    'dhruvasagar/vim-table-mode',
    ft = { 'markdown', 'org' },
    cmd = { 'TableModeToggle', 'TableModeEnable' },
    config = function()
        vim.cmd('runtime vim/config/table.vim')
    end
}
