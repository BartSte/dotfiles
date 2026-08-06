return {
    "dlyongemallo/diffview-plus.nvim",
    version = "*",
    cmd = {
        "DiffviewOpen",
        "DiffviewClose",
        "DiffviewFocusFiles",
        "DiffviewRefresh",
        "DiffviewToggleFiles",
    },
    keys = {
        {
            "<leader>gy",
            ":DiffviewOpen ",
            desc = "Review Git changes",
        },
    },
    opts = function()
        local actions = require("diffview.actions")

        local function navigation()
            return {
                {
                    "n",
                    "]q",
                    actions.select_next_entry,
                    { desc = "Open the next changed file" },
                },
                {
                    "n",
                    "[q",
                    actions.select_prev_entry,
                    { desc = "Open the previous changed file" },
                },
                {
                    "n",
                    "]Q",
                    actions.select_last_entry,
                    { desc = "Open the last changed file" },
                },
                {
                    "n",
                    "[Q",
                    actions.select_first_entry,
                    { desc = "Open the first changed file" },
                },
            }
        end

        return {
            view = {
                default = {
                    layout = "diff2_horizontal",
                    focus_diff = true,
                },
            },
            file_panel = {
                listing_style = "list",
                win_config = {
                    position = "bottom",
                    height = 10,
                },
            },
            keymaps = {
                view = navigation(),
                file_panel = navigation(),
            },
        }
    end,
}
