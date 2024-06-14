local path = require("helpers.path")

-- See: https://github.com/microsoft/pyright/blob/main/docs/settings.md
local pyright = {
    settings = {
        pyright = {
            disableOrganizeImports = true,
            disableTaggedHints = false,
        },
        python = {
            analysis = {
                autoImportCompletions = true,
                autoSearchPaths = false,
                useLibraryCodeForTypes = true,
                typeCheckingMode = "standard",
                diagnosticMode = "workspace",
                reportMissingTypeStubs = false,

                -- diagnosticMode = "openFilesOnly",
                -- stubPath = "typings",
            },
        },
    },
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

local marksman_win = {
    cmd = {
        "$LOCALAPPDATA\\nvim-data\\mason\\packages\\marksman\\marksman.exe",
        "server"
    }
}

local function get_marksman_opts()
    if vim.fn.has('win32') == 1 then
        return marksman_win
    else
        return {}
    end
end

local lsp = require('lspconfig')
lsp.pyright.setup(pyright)
lsp.clangd.setup(clangd)
lsp.cmake.setup({})
lsp.vimls.setup({})
lsp.lua_ls.setup(lua_ls)
lsp.bashls.setup(bashls)
lsp.jsonls.setup({})
lsp.marksman.setup(get_marksman_opts())
lsp.ruff_lsp.setup({})
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
