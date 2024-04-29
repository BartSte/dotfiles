return {
    "ibhagwan/fzf-lua",
    keys = { "<a-o>", "<a-b>", "<a-h>", "<a-v>", "<a-H>", "<a-a>", "<a-A>",
        "<a-B>", "<a-c>", "<a-r>", "<a-t>" },
    config = function()
        require("config.fzf")
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" }
}
