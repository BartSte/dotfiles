return {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
        require("lua.helpers.flash").setup()
    end
}
