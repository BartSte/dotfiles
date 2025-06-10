return {
    "Zeioth/garbage-day.nvim",
    event = "VeryLazy",
    cond = false,
    dependencies = "neovim/nvim-lspconfig",
    opts = {
        excluded_lsp_clients = { "gitlab_code_suggestions" }
    }
}
