return {
    'dhruvasagar/vim-table-mode',
    ft = { 'markdown', 'org' },
    command = { 'TableModeToggle', 'TableModeEnable' }, 
    config = function()
        vim.cmd('runtime vim/table.vim')
    end
}
