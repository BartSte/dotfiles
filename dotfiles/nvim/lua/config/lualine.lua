local lualine = require("lualine")
local helpers = require("helpers.lualine")
local icons = require("nvim-web-devicons")

local venv = {
    helpers.venv,
    icon = {
        icons.get_icon_by_filetype("python", {}),
        color = { fg = "darkyellow" }
    },
}

local filename = {
    "filename",
    path = 4,
    symbols = {
        modified = "✎ ",
        readonly = "❌"
    }
}

local fileformat = {
    "fileformat",
    padding = { left = 1, right = 2 }
}

local progress = {
    "progress",
    fmt = function(name, context) return "↕ " .. name end
}

lualine.setup({
    options = {
        icons_enabled = true,
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        globalstatus = true,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = {},
        lualine_c = { "branch", "diff", "diagnostics", venv, "copilot" },
        lualine_x = { filename, "filetype", fileformat, progress },
        lualine_y = {},
        lualine_z = { helpers.tabs }
    },
    extensions = { "fugitive", "fzf", "quickfix", "lazy", "mason", "oil" }
})
vim.opt.showtabline = 0
