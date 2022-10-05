"Clipboard for linux
if has('linux')
    nnoremap "*p :silent! r !xclip -selection clipboard -o<CR>
    nnoremap "*yy V:silent! w !xclip -selection clipboard<CR>    
    nnoremap "*dd V:silent! !xclip -selection clipboard<CR>
    vnoremap "*d :silent! !xclip -selection clipboard<CR>
    vnoremap "*y :silent! w !xclip -selection clipboard<CR>
endif

