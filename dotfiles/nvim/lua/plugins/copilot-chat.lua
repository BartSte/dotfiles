return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "github/copilot.vim" },
            { "nvim-lua/plenary.nvim", branch = "master" },
        },
        build = "make tiktoken",
        config = function()
            require("config.copilot-chat")
        end,
        cond = function()
            local has_gitlab = vim.env.GITLAB_TOKEN ~= nil or vim.env.GITLAB_TOKEN ~= ''
            return not has_gitlab
        end,
    },
}
