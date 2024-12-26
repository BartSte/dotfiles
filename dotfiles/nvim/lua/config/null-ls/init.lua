local null_ls = require("null-ls")
local notify = require("helpers.null-ls.notify")
local mappings = require('config.lsp.mappings')

---@class NullLsSource
---@field name string
---@field id integer
---@field methods table<string,boolean>

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
    null_ls.builtins.formatting.prettierd.with({
        extra_filetypes = { "toml" },
    }),
    null_ls.builtins.diagnostics.markdownlint.with({
        args = { "--stdin", "--disable", "MD013" },
    })
}
local opts = { fallback_value = {} }
local sources_project = require("projectrc").require("config.null-ls", opts)
vim.list_extend(sources, sources_project)
null_ls.setup({
    sources = sources,
    on_attach = function(client, buf)
        mappings.on_lsp_attach(client, buf)
        notify.attach(buf)
    end
})
