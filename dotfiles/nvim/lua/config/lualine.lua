local lualine = require("lualine")
local helpers = require("helpers.lualine")
local custom_auto = require("lualine.themes.auto")

custom_auto.inactive.c.bg = nil
custom_auto.inactive.c.gui = nil

lualine.setup({
    options = {
        icons_enabled = true,
        theme = custom_auto,
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        disabled_filetypes = {
            statusline = {},
        },
        ignore_focus = {},
        always_divide_middle = false,
        globalstatus = true,
        refresh = {
            statusline = 1000,
        }
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { "diff", "diagnostics", helpers.venv, "copilot" },
        lualine_x = {
            {
                "filename",
                path = 4,
                symbols = {
                    modified = "✎ ",
                    readonly = "❌"
                }
            },
            "filetype",
            {
                "progress",
                fmt = function(name, context) return "↕ " .. name end
            },
            {
                "fileformat",
                fmt = function(name, context) return name .. " " end
            },
        },
        lualine_y = {},
        lualine_z = { helpers.tabs }
    },
    extensions = { "fugitive", "fzf", "quickfix", "lazy", "mason", "oil" }
})

vim.opt.showtabline = 0
