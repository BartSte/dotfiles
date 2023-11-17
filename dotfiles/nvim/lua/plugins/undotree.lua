return {
    'mbbill/undotree',
    cmd = { 'UndotreeToggle' },
    keys = { '<M-u>' },
    config = function()
        vim.cmd('runtime vim/undotree.vim')
    end
}
