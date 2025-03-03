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
    -- Add this to your lua_ls config in neovim
    settings = {
      Lua = {
        workspace = {
          library = vim.api.nvim_get_runtime_file("lua", true)
        },
        diagnostics = {
          globals = { 'Snacks' }
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
