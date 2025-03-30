return {
    "olimorris/codecompanion.nvim",
    cond = false,
    config = function() require("config.codecompanion") end,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "Davidyz/VectorCode"
    },
}
