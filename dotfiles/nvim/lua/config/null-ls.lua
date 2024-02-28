local null_ls = require("null-ls")

local M = {}

M.sources = {
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

M.sources_extra = {
    require("none-ls.formatting.autopep8")
}

M.setup = function()
    null_ls.setup({ sources = M.sources })
end

M.setup_extra = function()
    null_ls.setup({ sources = M.sources_extra })
end

return M
