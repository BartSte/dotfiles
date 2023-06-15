require('nvim-treesitter.configs').setup {
    ensure_installed = {
        "markdown", "markdown_inline", "bash", "vim", "lua", "cpp", "python",
        "json", "cpp", "toml", "latex", "make", "gitcommit", "regex", "org"
    },
    sync_install = true,
    auto_install = true,
    highlight = {
        enable = true,
        disable = { 'org', 'orgagenda' },
        additional_vim_regex_highlighting = { 'org', 'orgagenda' }
    },
    indent = { enable = true }
}

require('nvim-treesitter.install').compilers = { "cl", "gcc", "clang" }

