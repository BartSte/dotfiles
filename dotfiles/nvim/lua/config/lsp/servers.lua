local path = require("helpers.path")

local basedpyright = {
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
}

local clangd = {
    cmd = {
        "clangd",
        "--offset-encoding=utf-16",
        "--header-insertion=iwyu",
        "--background-index",
        "--clang-tidy",
        "--pch-storage=memory",
    },
}

local lua_ls = {}

-- When installed, bashls uses `shellcheck` to provide diagnostics!
local bashls = { filetypes = { "sh", "bash", "zsh" } }

local lsp = require('lspconfig')
lsp.basedpyright.setup(basedpyright)
lsp.clangd.setup(clangd)
lsp.cmake.setup({})
lsp.vimls.setup({})
lsp.lua_ls.setup(lua_ls)
lsp.bashls.setup(bashls)
lsp.marksman.setup({})
lsp.jsonls.setup({})
lsp.ruff.setup({})

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
