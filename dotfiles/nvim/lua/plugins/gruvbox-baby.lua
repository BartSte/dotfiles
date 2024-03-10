return {
    'luisiacc/gruvbox-baby',
    branch = 'main',
    priority = 1000,
    lazy = false,
    config = function()
        require("config.gruvbox-baby")
        vim.cmd("runtime vim/config/gruvbox-baby.vim")
    end
}
