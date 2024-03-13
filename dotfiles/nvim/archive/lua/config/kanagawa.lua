return {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    lazy = false,
    config = function()
        require("config.kanagawa")
        vim.cmd("runtime vim/config/kanagawa.vim ")
    end
}
