return {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall" },
    build = ":MasonUpdate",
    config = function()
        require('mason').setup()
    end
}
