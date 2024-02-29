local function setup_mason()
    require("mason-null-ls").setup({ automatic_installation = true })
end

return {
    "nvimtools/none-ls.nvim",
    ft = { "python", "zsh", "sh", "bash", "markdown", "c", "cpp", "h", "hpp", "cmake" },
    event = { "BufReadPost", "BufNewFile" },
    config = require("config.null-ls").setup,
    dependencies = {
        "williamboman/mason.nvim",
        {
            "jay-babu/mason-null-ls.nvim",
            config = setup_mason
        },
    }
}
