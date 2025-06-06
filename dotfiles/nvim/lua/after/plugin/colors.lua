local set = vim.api.nvim_set_hl
local color1 = '#222222'

local highlight_setters = {
    ["gruvbox-baby"] = function()
        set(0, 'ColorColumn', { bg = color1 })
        set(0, 'CursorLine', { bg = color1 })
        set(0, 'CursorLineNr', { fg = '#fe8019', bg = color1 })
        set(0, 'FloatBorder', { fg = 'gray65', bg = 'NONE' })
        set(0, 'Folded', { fg = 'gray65' })
        set(0, 'IncSearch', { reverse = true, fg = '#fe8019', bg = '#1d2021' })
        set(0, 'LineNr', { fg = 'LightGray' })
        set(0, 'MatchParen', { bold = true, fg = '#fe8019', bg = '#1d2021' })
        set(0, 'Normal', { bg = "black" })
        set(0, 'SpellBad', { undercurl = true, sp = 'Red' })
        set(0, 'TabLine', { bg = 'NONE' })
        set(0, 'TabLineFill', { bg = 'NONE' })
        set(0, 'TabLineSel', { bg = 'NONE' })
        set(0, 'TreesitterContext', { bg = color1 })
        set(0, 'TreesitterContextBottom', { bold = true, bg = color1 })
        set(0, 'TreesitterContextLineNumber', { fg = '#fe8019', bg = color1 })
        set(0, 'WinSeparator', { fg = color1 })
    end
}


local function apply_highlights(colorscheme)
    local callback = highlight_setters[colorscheme]
    if callback then
        callback()
    end
    set(0, 'GitLabGhostText', { fg = 'gray65', italic = true })
    set(0, 'HighlightedyankRegion', { reverse = true, fg = '#fe8019', bg = '#1d2021' })
end

local function set_lualine(colorscheme)
    local theme = require("config.lualine.themes")[colorscheme] or 'auto'
    require("lualine").setup({ options = { theme = theme } })
end

--- Applies color scheme specific highlights when the colorscheme changes
vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
        apply_highlights(vim.g.colors_name)
        set_lualine(vim.g.colors_name)
    end
})
vim.cmd("colorscheme kanagawa")
