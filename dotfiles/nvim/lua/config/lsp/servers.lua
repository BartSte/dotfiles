local mappings = require('helpers.lsp.mappings')

return {
    ruff = {
        on_attach = function(client, buf)
            mappings.map_formatter({
                actions = { "source.organizeImports.ruff" }
            })
        end
    },

    basedpyright = {
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
                    globals = { "vim", "Snacks", "msg_ids" },
                },
            },
        },
    },

    cmake = {},
    vimls = {},
    marksman = {},
    jsonls = {},
}
