local lspconfig = require('lspconfig')

-- Python
lspconfig.pyright.setup({
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                -- diagnosticMode = "openFilesOnly",
                typeCheckingMode = "standard",
            },
        },
    },
})

-- Disable hover in favor of Pyright
local on_attach = function(client, bufnr)
    if client.name == 'ruff_lsp' then
        client.server_capabilities.hoverProvider = false
    end
end

lspconfig.ruff_lsp.setup {
    on_attach = on_attach,
    init_options = {
        settings = {
            -- Any extra CLI arguments for `ruff` go here.
            args = {},
        }
    }
}

-- C++
lspconfig.clangd.setup {
    cmd = {
        "clangd",
        "--offset-encoding=utf-16",
        "--header-insertion=iwyu",
        "--background-index",
        "--clang-tidy",
        "--pch-storage=memory",
    },
}
lspconfig.cmake.setup {}

--Vim
lspconfig.vimls.setup({})
lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
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
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

-- Shell
lspconfig.bashls.setup({ filetypes = { "sh", "bash", "zsh" } })

-- Misc
lspconfig.jsonls.setup({})

-- Windows
if vim.fn.has('win32') == 1 then
    lspconfig.powershell_es.setup({})
    lspconfig.marksman.setup({
        cmd = {
            "$LOCALAPPDATA\\nvim-data\\mason\\packages\\marksman\\marksman.exe",
            "server"
        }
    })
else
    lspconfig.marksman.setup({})
end
