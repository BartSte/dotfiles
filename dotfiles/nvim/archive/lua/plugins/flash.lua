-- I did not like flash as it took lots of effort to mimic the behavior of
-- hop.nvim (displaying multiple labels only when needed).
return {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
        require("lua.helpers.flash").setup()
    end
}
