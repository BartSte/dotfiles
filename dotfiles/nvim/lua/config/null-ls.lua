local null_ls = require("null-ls")

null_ls.setup({
    on_init = function(new_client, _)
        new_client.offset_encoding = 'utf-32'
    end,
    sources = {
        -- Python
        null_ls.builtins.formatting.autopep8,
        null_ls.builtins.formatting.ruff,
        null_ls.builtins.diagnostics.ruff,

        -- C++
        null_ls.builtins.diagnostics.cpplint,
        null_ls.builtins.formatting.cmake_format,
        null_ls.builtins.diagnostics.cmake_lint,

        -- Bash/zsh
        null_ls.builtins.formatting.shfmt.with({
            extra_args = { "-i", "4", "-ci" },
            filetypes = { "sh", "zsh", "bash" },
        }),
    },
})
