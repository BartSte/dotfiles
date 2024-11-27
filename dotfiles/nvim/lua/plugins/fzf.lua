return {
    "ibhagwan/fzf-lua",
    keys = {
        "<a-A>", "<a-D>", "<a-F>", "<a-H>", "<a-W>", "<a-a>", "<a-b>", "<a-d>",
        "<a-e>", "<a-f>", "<a-h>", "<a-r>", "<a-t>", "<a-v>", "<a-w>"
    },
    config = function()
        require("config.fzf")
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" }
}
