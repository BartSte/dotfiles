local function nvim_config_root(bufnr, callback)
    local path = require("helpers.path")
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local dotfiles_nvim = path.join(path.home(), "dotfiles", "nvim")

    if fname:sub(1, #dotfiles_nvim) == dotfiles_nvim then
        callback(dotfiles_nvim)
        return
    end

    callback(path.config_dir())
end

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
        root_dir = nvim_config_root,
        settings = {
            Lua = {
                codeLens = {
                    enable = true,
                },
                diagnostics = {
                    globals = {
                        "vim",
                        "Snacks",
                    },
                },
                hint = {
                    enable = true,
                    semicolon = "Disable",
                },
                runtime = {
                    version = "LuaJIT",
                    path = {
                        "?.lua",
                        "?/init.lua",
                        "lua/?.lua",
                        "lua/?/init.lua",
                    },
                },
                workspace = {
                    checkThirdParty = false,
                },
            },
        },
    },
    ruff = {},
    cmake = {},
    vimls = {},
    marksman = {},
    ltex_plus = {
        filetypes = { "markdown", "org", "text", "gitcommit" },
        settings = {
            ltex = {
                additionalRules = {
                    enablePickyRules = true,
                    motherTongue = "en",
                },
                checkFrequency = "save",
                language = "en-US",
            },
        },
    },
    jsonls = {},
    ts_ls = {},
    yamlls = {},
    taplo = {},
}
