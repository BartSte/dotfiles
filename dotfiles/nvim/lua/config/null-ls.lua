local M = {}

M.setup = function()
    local null_ls = require("null-ls")
    null_ls.setup({
        sources = {
            -- Python
            require("none-ls.formatting.autopep8"),
            null_ls.builtins.diagnostics.pylint,

            -- C++
            null_ls.builtins.formatting.cmake_format,
            null_ls.builtins.diagnostics.cmake_lint,

            -- Bash/zsh
            null_ls.builtins.formatting.shfmt.with({
                filetypes = { "sh", "bash", "zsh" },
                args = { "-i", "4" },
            }),

            -- Markdown
            null_ls.builtins.formatting.prettier.with({
                filetypes = { "markdown" },
            }),
            null_ls.builtins.diagnostics.markdownlint,
        }
    })
end


return M
