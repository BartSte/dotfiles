"Clipboard for linux
if has('linux')
    nnoremap "*yy V:silent! w !xclip -selection clipboard<CR>    
    nnoremap "*dd V:silent! !xclip -selection clipboard<CR>
    noremap "*p :silent! r !xclip -selection clipboard -o<CR>
    noremap "*d :silent! !xclip -selection clipboard<CR>
    noremap "*y :silent! w !xclip -selection clipboard<CR>
endif

