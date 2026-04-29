require('nvim-treesitter.install').compilers = { "cl", "gcc", "clang" }
require('nvim-treesitter').setup {
    ensure_installed = {
        "bash",
        "cpp",
        "cpp",
        "gitcommit",
        "json",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "toml",
        "vim",
        "yaml"
    },
    sync_install = false,
    auto_install = true,
    highlight = { enable = true },
}
