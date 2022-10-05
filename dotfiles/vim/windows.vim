if &term == "win32"
    " In powershell, <C-h> sends `Îz'. As a workaround, F13 is assigned to this
    " sequence.
    execute "set <F13>=\xce\x7a"
    inoremap <F13> <C-W>
    nnoremap <F13> <C-w>h

    " Cursorline does not work well in powershell
    set nocursorline

endif

if has('win32')
    let g:python3_host_prog = 'C:/Python310/python.exe'
endif
