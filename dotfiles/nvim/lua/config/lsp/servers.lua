---@type table<string, vim.lsp.Config>
return {
    basedpyright = {
        settings = {
            basedpyright = {
                disableOrganizeImports = true,
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

    ruff = {},
    cmake = {},
    vimls = {},
    marksman = {},
    jsonls = {},
    ts_ls = {},
    gitlab_ci_ls = {},
    yamlls = {}
}
