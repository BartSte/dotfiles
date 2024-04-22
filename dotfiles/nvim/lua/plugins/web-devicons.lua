return {
    "nvim-tree/nvim-web-devicons",
    config = function()
        require("nvim-web-devicons").setup({
            override_by_extension = {
                ["txt"] = { icon = "?" },
                ["svg"] = { icon = "?" },
            },
        })
    end
}
