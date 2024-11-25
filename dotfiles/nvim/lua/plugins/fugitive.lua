return {
    "tpope/vim-fugitive",
    keys = {
        { "<leader>g", "<leader>G" }
    },
    config = function()
        vim.cmd("runtime vim/config/fugitive.vim")
    end
}
