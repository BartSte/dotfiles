local path = require("helpers.path")
local lsp = require('lspconfig')
local capabilities = require('config.lsp.capabilities')

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
    lsp.lua_ls.setup({})

    --MD
    lsp.marksman.setup({})

    --JS/TS
    lsp.jsonls.setup({})

    --Powershell
    if vim.fn.has('win32') == 1 then
        local appdata = vim.fn.expand('$LOCALAPPDATA')
        local bundle_path = path.join(appdata, 'nvim-data', 'mason', 'packages', 'powershell-editor-services',
            'PowerShellEditorServices')
        local cmd = path.join(bundle_path, 'Start-EditorServices.ps1')
        lsp.powershell_es.setup({
            bundle_path = bundle_path,
            cmd = { 'pwsh', '-NoLogo', '-NoProfile', '-Command', cmd },
        })
    end
end

return M
