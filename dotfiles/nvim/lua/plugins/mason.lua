return {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall" },
    event = { "BufReadPost", "BufNewFile" },
    build = ":MasonUpdate",
    config = function()
        require('mason').setup()
    end
}
