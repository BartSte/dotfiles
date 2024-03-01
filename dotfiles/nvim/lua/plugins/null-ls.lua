return {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "nvimtools/none-ls.nvim",
    },
    config = function()
        require("config.mason").setup()
        require("config.mason-null-ls").setup()
        require("config.null-ls").setup()
    end
}
