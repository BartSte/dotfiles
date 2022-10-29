" Vertical split help by default
augroup vertical_help
    autocmd!
    autocmd FileType help
                \ setlocal bufhidden=unload |
                \ wincmd L |
                \ vertical resize 85
augroup END

