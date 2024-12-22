local lsp = require('lspconfig')
local capabilities = require("projectrc").require('config.lsp.capabilities')

local M = {}

M.setup = function()
    --Python
    lsp.ruff.setup({
        on_attach = capabilities.ruff,
    })
    lsp.basedpyright.setup({
        settings = {
            basedpyright = {
                disableOrganizeImports = true,
                analysis = {
                    diagnosticSeverityOverrides = {
                        reportMissingTypeStubs = "none"
                    }
                }
            }
        }
    })

    -- C/C++
    lsp.cmake.setup({})
    lsp.clangd.setup({
        cmd = {
            "clangd",
            "--offset-encoding=utf-16",
            "--header-insertion=iwyu",
            "--background-index",
            "--clang-tidy",
            "--pch-storage=memory",
        },
    })

    --Shell
    lsp.bashls.setup({ filetypes = { "sh", "bash", "zsh" } })

    --Nvim
    lsp.vimls.setup({})
    lsp.lua_ls.setup({
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim", "Snacks" },
                },
            },
        },
    })

    --MD
    lsp.marksman.setup({})

    --JS/TS
    lsp.jsonls.setup({})
end

return M
