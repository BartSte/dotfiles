local M = {}

M.setup = function()
    local null_ls = require("null-ls")
    local formatters = require("helpers.null-ls.formatters")

    local sources = {
        -- Python
        formatters.autoflake,
        formatters.autopep8,
        formatters.isort,
        null_ls.builtins.diagnostics.pylint,
        -- C++
        null_ls.builtins.formatting.cmake_format,
        null_ls.builtins.diagnostics.cmake_lint,
        -- Shell
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

    null_ls.setup({ sources = sources })
end


return M
