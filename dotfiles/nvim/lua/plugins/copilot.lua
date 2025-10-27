return {
    "github/copilot.vim",
    event = { "BufReadPre", "BufNewFile" },
    cond = function()
        local has_gitlab = vim.env.GITLAB_TOKEN ~= nil or vim.env.GITLAB_TOKEN ~= ''
        local has_node = vim.fn.executable("node") == 1
        return has_node and not has_gitlab
    end,
    config = function()
        require("config.copilot")
    end,
}
