return {
    "olimorris/codecompanion.nvim",
    config = function()
        require("config.codecompanion")
    end,
    cond = function()
        return vim.env.OPENAI_API_KEY ~= nil and vim.env.OPENAI_API_KEY ~= ""
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
}
