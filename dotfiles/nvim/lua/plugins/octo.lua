return {
    "pwntester/octo.nvim",
    cmd = "Octo",
    keys = { { "<leader>n" } },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "ibhagwan/fzf-lua",
    },
    config = function()
        require("config.octo")
    end
}
