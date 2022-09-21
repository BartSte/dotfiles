" Vertical split help by default
augroup vertical_help
    autocmd!
    autocmd FileType help
                \ setlocal bufhidden=unload |
                \ wincmd L |
                \ vertical resize 79
augroup END

" Coc
command! -nargs=0 Format :call CocActionAsync('format')
command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction

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
