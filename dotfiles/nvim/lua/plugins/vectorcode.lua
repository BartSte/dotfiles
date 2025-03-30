return {
    "Davidyz/VectorCode",
    cond = false,
    version = "*",                     -- optional, depending on whether you're on nightly or release
    build = "pipx upgrade vectorcode", -- optional but recommended if you set `version = "*"`
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("config.vectorcode")
    end
}
