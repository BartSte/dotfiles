--- Configures highlight groups for color schemes
local set = vim.api.nvim_set_hl

local color1 = '#222222'

--- Sets highlight groups for the gruvbox-baby color scheme
local highlight_setters = {
    ["gruvbox-baby"] = function()
        --- Set various highlight groups for gruvbox-baby theme
        set(0, 'ColorColumn', { bg = color1 })
        set(0, 'CursorLine', { bg = color1 })
        set(0, 'CursorLineNr', { fg = '#fe8019', bg = color1 })
        set(0, 'FloatBorder', { fg = 'gray65', bg = 'NONE' })
        set(0, 'Folded', { fg = 'gray65' })
        set(0, 'GitLabGhostText', { fg = 'gray65', italic = true })
        set(0, 'HighlightedyankRegion', { reverse = true, fg = '#fe8019', bg = '#1d2021' })
        set(0, 'HopNextKey', { bg = 'NONE' })
        set(0, 'HopNextKey1', { bg = 'NONE' })
        set(0, 'HopNextKey2', { bg = 'NONE' })
        set(0, 'IncSearch', { reverse = true, fg = '#fe8019', bg = '#1d2021' })
        set(0, 'LineNr', { fg = 'LightGray' })
        set(0, 'MatchParen', { bold = true, fg = '#fe8019', bg = '#1d2021' })
        set(0, 'Normal', { bg = "#000000" })
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

--- Applies color scheme specific highlights when the colorscheme changes
vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
        --- Lookup and execute highlight setter for current colorscheme
        local callback = highlight_setters[vim.g.colors_name]
        if callback then
            callback()
        end
    end
})

vim.cmd("colorscheme gruvbox-baby")
