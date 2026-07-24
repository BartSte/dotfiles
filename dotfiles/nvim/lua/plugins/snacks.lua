return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function()
        require("config.snacks")
    end,
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    }
}
