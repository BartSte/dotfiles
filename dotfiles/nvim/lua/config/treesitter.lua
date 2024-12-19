require 'nvim-treesitter.install'.compilers = { "cl", "gcc", "clang" }
require 'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "markdown", "markdown_inline", "bash", "vim", "lua", "cpp", "python",
        "json", "cpp", "toml", "make", "gitcommit"
    },
    sync_install = false,
    ignore_install = { "org" },
    auto_install = true,
    highlight = {
        enable = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the
        -- same time. Set this to `true` if you depend on 'syntax' being
        -- enabled (like for indentation). Using this option may slow down your
        -- editor, and you may see some duplicate highlights. Instead of true
        -- it can also be a list of languages
        additional_vim_regex_highlighting = { "puml" },
    },
}
