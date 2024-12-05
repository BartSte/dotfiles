return {
    'arnamak/stay-centered.nvim',
    event  = { 'BufEnter', 'CursorMoved', 'CursorMovedI' },
    config = function()
        require('stay-centered').setup({ allow_scroll_move = false })
    end,
}
