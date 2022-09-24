if &term == "win32"
    " In powershell, <C-h> sends `Îz'. As a workaround, F13 is assigned to this
    " sequence.
    execute "set <F13>=\xce\x7a"
    inoremap <F13> <C-W>
    nnoremap <F13> <C-w>h

    " Cursorline does not work well in powershell
    set nocursorline
endif
