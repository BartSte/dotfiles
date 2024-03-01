return {
    "nvimtools/none-ls.nvim",
    ft = { "python", "zsh", "sh", "bash", "markdown", "c", "cpp", "h", "hpp", "cmake" },
    event = { "BufReadPost", "BufNewFile" },
    config = require("config.null-ls").setup
}
