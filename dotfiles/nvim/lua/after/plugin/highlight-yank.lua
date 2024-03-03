local M = {}

local function highlight_yank()
    local group = (vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch')
    local opts = { higroup = group, timeout = 200 }
    vim.highlight.on_yank(opts)
end

M.setup = function()
    vim.api.nvim_create_autocmd('TextYankPost', { callback = highlight_yank })
end

return M
