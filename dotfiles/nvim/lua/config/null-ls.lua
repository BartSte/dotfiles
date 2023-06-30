local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.autopep8,
        null_ls.builtins.formatting.ruff,
        null_ls.builtins.diagnostics.ruff,
        null_ls.builtins.formatting.cbfmt,
        null_ls.builtins.formatting.shfmt.with({
            extra_args = { "-i", "4", "-ci" },
            filetypes = { "sh", "zsh", "bash" },
        })
    },
})
