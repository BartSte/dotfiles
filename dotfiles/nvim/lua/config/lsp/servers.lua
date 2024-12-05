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

local lua_ls = {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're
                -- using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but
            -- unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

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
