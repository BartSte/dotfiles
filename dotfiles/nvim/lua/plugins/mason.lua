return {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall" },
    build = ":MasonUpdate",
    config = function()
        require("config.mason")
    end
}
