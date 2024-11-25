return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function()
        require("config.snacks")
    end,
    dependencies = {
        "echasnovski/mini.icons",
        "nvim-tree/nvim-web-devicons"
    }
}
