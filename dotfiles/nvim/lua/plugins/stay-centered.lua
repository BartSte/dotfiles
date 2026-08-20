return {
    'arnamak/stay-centered.nvim',
    event = { 'CursorMoved', 'CursorMovedI' },
    config = function()
        require('stay-centered').setup({
            allow_scroll_move = false,
            disable_on_mouse = false,
            skip_filetypes = {
                "bigfile",
                "floggraph",
                "fzf",
                "help",
                "lazy",
                "mason",
                "oil",
                "qf",
            },
        })
    end,
}
