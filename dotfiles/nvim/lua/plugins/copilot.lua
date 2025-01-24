-- return {
--     'zbirenbaum/copilot.lua',
--     cmd = "Copilot",
--     event = { "BufReadPre", "BufNewFile" },
--     cond = function()
--         return vim.fn.executable("node") == 1
--     end,
--     config = function()
--         require("config.copilot")
--     end,
-- }

return {
    "github/copilot.vim",
    event = { "BufReadPre", "BufNewFile" },
    cond = function()
        return vim.fn.executable("node") == 1
    end,
    config = function()
        require("config.copilot")
    end,
}

