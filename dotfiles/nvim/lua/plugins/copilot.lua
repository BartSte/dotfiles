return {
    'zbirenbaum/copilot.lua',
    cmd = "Copilot",
    event = "InsertEnter",
    cond = function()
        return vim.fn.executable("node") == 1
    end,
    config = function()
        require("config.copilot")
    end,
}
