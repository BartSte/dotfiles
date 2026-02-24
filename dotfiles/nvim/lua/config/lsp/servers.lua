---@type table<string, vim.lsp.Config>
return {
    basedpyright = {
        single_file_support = false,
        settings = {
            basedpyright = {
                disableOrganizeImports = true,
                analysis = {
                    inlayHints = {
                        variableTypes = true,
                        callArgumentNamesMatching = true,
                        functionReturnTypes = true,
                        genericTypes = true,
                    }
                },
            },
        },
    },

    clangd = {
        cmd = {
            "clangd",
            "--offset-encoding=utf-16",
            "--header-insertion=iwyu",
            "--background-index",
            "--clang-tidy",
            "--pch-storage=memory",
        },
    },

    bashls = { filetypes = { "sh", "bash", "zsh" } },

    lua_ls = {
        settings = {
            Lua = {
                codeLens = {
                    enable = true
                },
                hint = {
                    enable = true,
                    semicolon = "Disable"
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
            }
        }
    },

    ruff = {},
    cmake = {},
    vimls = {},
    marksman = {},
    jsonls = {},
    ts_ls = {},
    yamlls = {},
    taplo = {},
}
