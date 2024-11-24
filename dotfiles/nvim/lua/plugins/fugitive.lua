return {
    "tpope/vim-fugitive",
    keys = {
        { "<space>g", "<space>G"}
    },
    config = function()
        vim.cmd("runtime vim/config/fugitive.vim")
    end
}
