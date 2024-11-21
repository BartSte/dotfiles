return {
    'mbbill/undotree',
    cmd = { 'UndotreeToggle' },
    keys = { '<M-u>', "<M-U>" },
    config = function()
        vim.cmd('runtime vim/config/undotree.vim')
    end
}
