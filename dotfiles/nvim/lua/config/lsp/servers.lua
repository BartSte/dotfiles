local M = {}

local pyright = {
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "standard",
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

M.setup = function()
    local lsp = require('lspconfig')
    lsp.pyright.setup(pyright)
    lsp.clangd.setup(clangd)
    lsp.cmake.setup({})
    lsp.vimls.setup({})
    lsp.lua_ls.setup(lua_ls)
    lsp.bashls.setup(bashls)
    lsp.jsonls.setup({})
    lsp.marksman.setup(get_marksman_opts())
    if vim.fn.has('win32') == 1 then
        lsp.powershell_es.setup({})
    end
end

return M
