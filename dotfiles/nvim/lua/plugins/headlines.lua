return {
    "lukas-reineke/headlines.nvim",
    ft = { "org" },
    config = function()
        require("headlines").setup()
    end,
}
