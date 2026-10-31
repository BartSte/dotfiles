return {
    "pwntester/octo.nvim",
    cmd = "Octo",
    event = "VeryLazy",
    keys = {
        { "<leader>pc", "<cmd>Octo pr list<CR>", desc = "PRs: current repository" },
        { "<leader>pp", function() require("helpers.pr_inbox").open("all") end, desc = "PRs: combined inbox" },
        { "<leader>pr", function() require("helpers.pr_inbox").open("review") end, desc = "PRs: needs your review" },
        { "<leader>pt", function() require("helpers.pr_inbox").open("team") end, desc = "PRs: needs your teams' review" },
        { "<leader>pd", function() require("helpers.pr_inbox").open("drafts") end, desc = "PRs: your drafts" },
        { "<leader>pw", function() require("helpers.pr_inbox").open("waiting") end, desc = "PRs: waiting for review or checks" },
        { "<leader>pa", function() require("helpers.pr_inbox").open("action") end, desc = "PRs: needs action" },
        { "<leader>pm", function() require("helpers.pr_inbox").open("ready") end, desc = "PRs: ready to merge" },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "ibhagwan/fzf-lua",
    },
    config = function()
        require("config.octo")
        require("helpers.pr_inbox").setup()
    end
}
