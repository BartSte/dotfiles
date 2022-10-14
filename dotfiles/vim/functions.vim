" Vertical split help by default
augroup vertical_help
    autocmd!
    autocmd FileType help
                \ setlocal bufhidden=unload |
                \ wincmd L |
                \ vertical resize 85
augroup END

" FZF
command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* Ag 
            \ call fzf#vim#ag(<q-args>, "--hidden --skip-vcs-ignores --path-to-ignore " . $HOME . "\\.ignore", fzf#vim#with_preview(), <bang>0)

" Vimspector
function! MyUnitTestStrategy(cmd)
    let testName = split(a:cmd)[-1]
    call vimspector#LaunchWithSettings( #{ configuration: 'unittest', TestName: testName } )
endfunction
