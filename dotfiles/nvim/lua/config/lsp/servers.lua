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
        runtime = {
          version = 'LuaJIT'
        },
        completion = {
          autoRequire = true,
        },
        format = {
          enable = true,
          defaultConfig = {
            line_length = 100,
            indent_style = 'space',
            indent_size = 2,
          }
        },
        diagnostics = {
          globals = { 'vim', 'Snacks' },
          neededFileStatus = {
            ['codestyle.long_line'] = 'Any',
          },
          groupSeverity = {
            strong = 'Warning',
          },
          groupFileStatus = {
            ['codestyle'] = 'Opened',
          },
        },
        workspace = {
          maxPreload = 2000,
          preloadFileSize = 500,
          checkThirdParty = false,
          library = vim.api.nvim_get_runtime_file("lua", true)
        },
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
