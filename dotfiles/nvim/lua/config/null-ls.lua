local keymapper = require('helpers.keymapper')

local M = {}

M.setup = function()
    local null_ls = require("null-ls")
    null_ls.setup({
        sources = {
            -- Python
            require("none-ls.formatting.autopep8"),
            require("none-ls.formatting.ruff"),
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

-- map leader + f to format the entire file. This can be done using gggqG, but
-- we need to make sure the cursor is returned its original position.
local function format_file()
    local cursor = vim.fn.getpos('.')
    if cursor == nil then
        vim.notify('Cursor position not found', vim.log.levels.ERROR)
    else
        vim.cmd('normal! gggqG')
        vim.fn.setpos('.', cursor)
    end
end
keymapper.buffer_nnoremap('<leader>f', format_file)


return M
