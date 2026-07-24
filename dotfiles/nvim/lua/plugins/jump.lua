return {
    "yorickpeterse/nvim-jump",
    keys = {
        { "h", mode = { "n", "x", "o" } },
    },
    config = function()
        require("config.jump")
    end,
}
