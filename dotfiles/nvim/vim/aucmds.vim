" Vertical split help by default
augroup vertical_help
    autocmd!
    autocmd FileType help
                \ setlocal bufhidden=unload |
                \ wincmd L |
                \ vertical resize 85
augroup END

autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'), timeout=200}
