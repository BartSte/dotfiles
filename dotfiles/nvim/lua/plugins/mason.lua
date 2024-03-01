return {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall" },
    build = ":MasonUpdate",
    config = require("config.mason").setup
}
