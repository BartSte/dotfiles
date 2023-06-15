return {
    { "williamboman/mason.nvim",           build = ":MasonUpdate" },
    { "williamboman/mason-lspconfig.nvim", dependencies = { "williamboman/mason.nvim" } },
    { "jay-babu/mason-null-ls.nvim",       dependencies = { "williamboman/mason.nvim" } },
}
