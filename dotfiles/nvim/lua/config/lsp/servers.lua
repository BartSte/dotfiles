---@type table<string, vim.lsp.Config>
return {
    basedpyright = {
        settings = {
            basedpyright = {
                disableOrganizeImports = true,
            },
            python = {
                analysis = {
                    autoSearchPaths = false,
                    diagnosticMode = "openFilesOnly",
                    useLibraryCodeForTypes = false,
                    exclude = { "venv", ".git", "build", "dist" },
                    diagnosticSeverityOverrides = {
                        reportUnusedCallResult = false,
                    },
                }
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
                workspace = {
                    library = vim.api.nvim_get_runtime_file("lua", true),
                }
            }
        }
    },

    ruff = {
        extra_args = { "--select", "F401", "--fix" }
    },
    cmake = {},
    vimls = {},
    marksman = {},
    jsonls = {},
    ts_ls = {},
    gitlab_ci_ls = {},
    yamlls = {}
}
