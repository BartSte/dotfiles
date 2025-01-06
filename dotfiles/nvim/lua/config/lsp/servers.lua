return {
    basedpyright = {
        settings = {
            basedpyright = {
                disableOrganizeImports = true,
            },
            python = {
                analysis = {
                    diagnosticSeverityOverrides = {
                        reportUnusedCallResult = false,
                    },
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
                diagnostics = {
                    globals = { "vim", "Snacks" },
                },
            },
        },
    },

    ruff = {
        extra_args = { "--select", "F401", "--fix" }
    },
    cmake = {},
    vimls = {},
    marksman = {},
    jsonls = {},
}
