return {
    "github/copilot.vim",
    event = "InsertEnter",
    cmd = "Copilot",
    keys = "<leader>co",
    cond = function()
        return vim.fn.executable("node") == 1
    end,
    config = function()
        require("config.copilot")
    end,
}
