local function make_gruvbox()
    local colors = require("gruvbox-baby.colors").config()
    colors.background = "#000000"
    local theme = {
        normal = {
            a = { bg = colors.light_blue, fg = colors.dark, gui = "bold" },
            b = { bg = colors.background, fg = colors.light_blue },
            c = { bg = colors.background, fg = colors.milk },
        },
        insert = {
            a = { bg = colors.bright_yellow, fg = colors.dark, gui = "bold" },
            b = { bg = colors.background, fg = colors.bright_yellow },
            c = { bg = colors.background, fg = colors.milk },
        },
        visual = {
            a = { bg = colors.milk, fg = colors.dark, gui = "bold" },
            b = { bg = colors.background, fg = colors.milk },
            c = { bg = colors.background, fg = colors.milk },
        },
        replace = {
            a = { bg = colors.error_red, fg = colors.dark, gui = "bold" },
            b = { bg = colors.background, fg = colors.error_red },
            c = { bg = colors.background, fg = colors.milk },
        },
        command = {
            a = { bg = colors.soft_green, fg = colors.dark, gui = "bold" },
            b = { bg = colors.background, fg = colors.soft_green },
            c = { bg = colors.background, fg = colors.milk },
        },
        inactive = {
            a = { bg = colors.dark_gray, fg = colors.gray, gui = "bold" },
            b = { bg = colors.dark_gray, fg = colors.gray },
            c = { bg = colors.dark_gray, fg = colors.gray },
        },
    }
    theme.terminal = theme.insert
    return theme
end

local function make_kanagawa()
    local colors = require("kanagawa.colors").setup({ theme = 'dragon' })
    --- TODO: circular require
    local theme = require("lualine.themes.auto")
    theme.normal.c.bg = colors.theme.ui.bg
    return theme
end



local M = {
    ["gruvbox-baby"] = make_gruvbox()
}

return M
