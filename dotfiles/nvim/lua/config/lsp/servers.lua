local lsp = require('lspconfig')
local mappings = require('config.lsp.mappings')
local capabilities = require('config.lsp.capabilities')
local helpers = require('helpers.lsp')

local M = {}

local opts = {

    ruff = {
        on_attach = function(...)
            mappings.map_code_action({ "source.organizeImports.ruff" })
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

---Setup the lsp servers.
---The on_attach function can be used to setup configurations that are specific
---to a server. Server capabilities can be specified in the capabilities module.
---Here, a decorator is used to update the capabilities of all servers. If the
---server is not specified in the capabilities module, no changes are made.
M.setup = function()
    for server, config in pairs(opts) do
        config.on_attach = helpers.notify.attach_decorator(config.on_attach)
        config.on_attach = capabilities.decorate(config.on_attach)
        lsp[server].setup(config)
    end
end

return M
