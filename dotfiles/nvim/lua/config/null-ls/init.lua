local M = {}

M.setup = function()
    local null_ls = require("null-ls")
    local sources = {
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
    local sources_project = require("helpers.projectrc").require("config.null-ls")

    sources = vim.tbl_extend("force", sources, sources_project)
    null_ls.setup({ sources = sources })
end


return M
