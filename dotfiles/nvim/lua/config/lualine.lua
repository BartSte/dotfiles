local map = require("helpers.keymapper")
local icons = require("nvim-web-devicons")
local lualine = require("lualine")
local helpers = require("helpers.lualine")

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
        modified = "📝",
        readonly = "🔒"
    }
}

local fileformat = {
    "fileformat",
    padding = { left = 1, right = 2 }
}

local progress = {
    "progress",
    icon = "↕"
}

local projectrc = {
    function() return require("projectrc").get_name() end,
    condition = function() return require("projectrc").get_name() ~= "" end,
    icon = "🛠",
}

local marks = {
    helpers.marks,
    icon = "🔖",
}

vim.cmd("command! AddMark lua require('helpers.lualine').add_mark()")
map.silent_noremap("m", ":AddMark<CR>")
-- TODO: also override the delmark command such that lualine updates accordingly

lualine.setup({
    options = {
        refresh = {
            statusline = 1000,
        },
        icons_enabled = true,
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        globalstatus = true,
    },
    sections = {
        -- State of the editor
        lualine_a = { "mode" },
        -- Same for all files
        lualine_b = { "copilot", helpers.shada, projectrc, venv },

        -- Changes when switching buffers
        lualine_c = { "branch", "diff", "diagnostics", marks },
        lualine_x = { filename, "filetype", progress },

        -- Same for all files
        lualine_y = { fileformat },

        -- State of the editor
        lualine_z = { helpers.tabs }
    },
    extensions = { "fugitive", "fzf", "quickfix", "lazy", "mason", "oil" }
})
vim.opt.showtabline = 0
