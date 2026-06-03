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

local basedpyright_project_markers = {
    "pyrightconfig.json",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
}

---@param fname string
---@return string|nil
local function find_git_root(fname)
    local git_marker = vim.fs.find(".git", { path = fname, upward = true })[1]
    if not git_marker then
        return nil
    end

    local stat = vim.uv.fs_stat(git_marker)
    if stat and stat.type == "file" then
        return vim.fs.dirname(git_marker)
    end

    if stat and stat.type == "directory" and vim.uv.fs_stat(vim.fs.joinpath(git_marker, "HEAD")) then
        return vim.fs.dirname(git_marker)
    end

    return nil
end

---@type table<string, vim.lsp.Config>
return {
    basedpyright = {
        single_file_support = false,
        root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            local git_root = find_git_root(fname)
            if git_root then
                on_dir(git_root)
                return
            end

            local project_root = vim.fs.root(fname, basedpyright_project_markers)
            if project_root then
                on_dir(project_root)
            end
        end,
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
