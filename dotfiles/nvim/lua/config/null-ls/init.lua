local M = {}

M.setup = function()
    local null_ls = require("null-ls")

    local sources = {
        -- Python
        require("helpers.null-ls.formatters").autoflake,
        require("helpers.null-ls.formatters").isort,
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
        null_ls.builtins.diagnostics.markdownlint.with({
            args = { "--stdin", "--disable", "MD013" },
        })
    }
    local opts = { fallback_value = {} }
    local sources_project = require("projectrc").require("config.null-ls", opts)
    vim.list_extend(sources, sources_project)
    null_ls.setup({ sources = sources })
end


return M
