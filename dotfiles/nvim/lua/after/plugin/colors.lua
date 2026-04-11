local set = vim.api.nvim_set_hl

local highlight_setters = {
    ["kanagawa"] = function()
        set(0, 'Folded', { fg = 'gray65' })
        set(0, 'LineNr', { fg = 'LightGray' })
        set(0, 'FlashLabel', { bg = '#ff007c', bold = true, fg = '#c8d3f5' })
    end
}

local function apply_highlights(colorscheme)
    local callback = highlight_setters[colorscheme]
    if callback then
        callback()
    end
    set(0, 'CopilotSuggestion', { fg = 'LightGray' })
    set(0, 'HighlightedyankRegion', { reverse = true, fg = '#fe8019', bg = '#1d2021' })
end

--- Applies color scheme specific highlights when the colorscheme changes
vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
        apply_highlights(vim.g.colors_name)
    end
})
vim.cmd("colorscheme kanagawa")
