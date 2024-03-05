return {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall" },
    build = ":MasonUpdate",
    config = require("mason").setup
}
