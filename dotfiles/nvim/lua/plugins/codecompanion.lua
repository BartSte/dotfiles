return {
    "olimorris/codecompanion.nvim",
    config = function()
        require("config.codecompanion")
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
}
