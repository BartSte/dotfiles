return {
    'mbbill/undotree',
    cmd = { 'UndotreeToggle' },
    keys = { '<M-u>' },
    config = function()
        vim.cmd('runtime vim/config/undotree.vim')
    end
}
