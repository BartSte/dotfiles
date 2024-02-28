local M = {}

M.setup = function()
    local null_ls = require("null-ls")
    null_ls.setup({
        sources = {
            -- Python
            null_ls.builtins.diagnostics.pylint,

            -- C++
            null_ls.builtins.formatting.cmake_format,
            null_ls.builtins.diagnostics.cmake_lint,

            -- Bash/zsh
            null_ls.builtins.formatting.shfmt.with({
                extra_args = { "-i", "4", "-ci" },
                filetypes = { "sh", "zsh", "bash" },
            }),

            -- Markdown
            null_ls.builtins.formatting.prettier.with({
                filetypes = { "markdown" },
            }),
            null_ls.builtins.diagnostics.markdownlint,
        }
    })
end

M.setup_extra = function()
    require("null-ls").setup({
        sources = require("none-ls.formatting.autopep8")
    })
end

return M
