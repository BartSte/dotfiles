local fn = require("helpers.fn")
local helpers = require("helpers.lualine")
local icons = require("nvim-web-devicons")
local lualine = require("lualine")
local projectmarks = require("projectmarks.lualine")
local themes = require("config.lualine.themes")
local prompts = fn.try_require("prompts.lualine")
local aider_icon = prompts and prompts.aider_icon

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

lualine.setup({
    options = {
        icons_enabled = true,
        section_separators = get_section_separator(),
        component_separators = get_component_separator(),
        globalstatus = true,
        theme = themes[vim.g.colors_name] or 'auto'
    },
    sections = {
        -- State of the editor
        lualine_a = { "mode" },

        -- Same for all files
        lualine_b = { aider_icon, projectmarks.shada, projectrc, venv },

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
