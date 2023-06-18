require 'nvim-treesitter.install'.compilers = { "cl", "gcc", "clang" }

local my_highlight = {
    enable = true,
    disable = { 'org', 'orgagenda' },
    additional_vim_regex_highlighting = { 'org', 'orgagenda' }
}

require 'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "markdown", "markdown_inline", "bash", "vim", "lua", "cpp", "python",
        "json", "cpp", "toml", "latex", "make", "gitcommit"
    },
    sync_install = true,
    auto_install = true,
    ignore_install = {},
    highlight = my_highlight,
    indent = { enable = true }
}
