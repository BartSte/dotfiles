local icons = require("nvim-web-devicons")
local lualine = require("lualine")
local helpers = require("helpers.lualine")
local projectmarks = require("projectmarks.lualine")
local prompts = require("prompts.lualine").aider_icon

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

local location = {
    "location",
}

local projectrc = {
    function() return require("projectrc").get_name() end,
    condition = function() return require("projectrc").get_name() ~= "" end,
    icon = "🛠",
}

local gitlab = {
    helpers.gitlab.state.get_icon,
    condition = function() return true end
}

local function get_section_separator()
    if vim.fn.has("gui_running") == 1 then
        return { left = "", right = "" }
    else
        return { left = "", right = "" }
    end
end

local get_component_separator = function()
    if vim.fn.has("gui_running") == 1 then
        return { left = "", right = "" }
    else
        return { left = "", right = "" }
    end
end

local c = require("gruvbox-baby.colors").config()
c.background = "#000000"
local custom = {
    normal = {
        a = { bg = c.light_blue, fg = c.dark, gui = "bold" },
        b = { bg = c.background, fg = c.light_blue },
        c = { bg = c.background, fg = c.milk },
    },
    insert = {
        a = { bg = c.bright_yellow, fg = c.dark, gui = "bold" },
        b = { bg = c.background, fg = c.bright_yellow },
        c = { bg = c.background, fg = c.milk },
    },
    visual = {
        a = { bg = c.milk, fg = c.dark, gui = "bold" },
        b = { bg = c.background, fg = c.milk },
        c = { bg = c.background, fg = c.milk },
    },
    replace = {
        a = { bg = c.error_red, fg = c.dark, gui = "bold" },
        b = { bg = c.background, fg = c.error_red },
        c = { bg = c.background, fg = c.milk },
    },
    command = {
        a = { bg = c.soft_green, fg = c.dark, gui = "bold" },
        b = { bg = c.background, fg = c.soft_green },
        c = { bg = c.background, fg = c.milk },
    },
    inactive = {
        a = { bg = c.dark_gray, fg = c.gray, gui = "bold" },
        b = { bg = c.dark_gray, fg = c.gray },
        c = { bg = c.dark_gray, fg = c.gray },
    },
}

custom.terminal = custom.insert

lualine.setup({
    options = {
        icons_enabled = true,
        section_separators = get_section_separator(),
        component_separators = get_component_separator(),
        globalstatus = true,
        theme = custom
    },
    sections = {
        -- State of the editor
        lualine_a = { "mode" },

        -- Same for all files
        lualine_b = { prompts, gitlab, projectmarks.shada, projectrc, venv },

        -- Changes when switching buffers
        lualine_c = { "branch", "diff", "diagnostics", projectmarks.marks_optimized },
        lualine_x = { filename, "filetype", fileformat },

        -- Same for all files
        lualine_y = { progress, location },

        -- State of the editor
        lualine_z = { helpers.tabs }
    },
    extensions = { "fugitive", "fzf", "quickfix", "lazy", "mason", "oil" }
})
vim.opt.showtabline = 0
