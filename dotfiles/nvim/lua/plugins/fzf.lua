return {
    "ibhagwan/fzf-lua",
    keys = {
        "<a-A>", "<a-C>", "<a-O>", "<a-V>", "<a-W>", "<a-a>", "<a-a>", "<a-b>",
        "<a-c>", "<a-d>", "<a-h>", "<a-o>", "<a-r>", "<a-t>", "<a-v>", "<a-w>",
        "<a-B>", "<a-s>"
    },
    config = function()
        require("config.fzf")
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" }
}
