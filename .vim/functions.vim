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

" Customize vimspector gui
function! s:CustomiseUI()
    " Change the Winbar of the code window
    call win_gotoid( g:vimspector_session_windows.code )
    nunmenu WinBar
    nnoremenu <silent>WinBar.Stop(F3) :call vimspector#Stop( { 'interactive': v:false } )<CR>
    nnoremenu <silent>WinBar.Restart(F4) :call vimspector#Restart()<CR>
    nnoremenu <silent>WinBar.Cont(F5) :call vimspector#Continue()<CR>
    nnoremenu <silent>WinBar.Break(F6) :call vimspector#Pause()<CR>
    nnoremenu <silent>WinBar.Reset(F7) :call vimspector#Reset( { 'interactive': v:false } )<CR>
    nnoremenu <silent>WinBar.Next(F10) :call vimspector#StepOver()<CR>
    nnoremenu <silent>WinBar.Step(F11) :call vimspector#StepInto()<CR>
    nnoremenu <silent>WinBar.Out(F12) :call vimspector#StepOut()<CR>
    
    " Creat 1 output window for the other buffers.
    only
    vsplit
    nnoremenu <silent>WinBar.Console :b vimspector.Console<CR>
    nnoremenu <silent>WinBar.Errors :b vimspector.Output:stderr<CR>
    nnoremenu <silent>WinBar.Server :b vimspector.output:server<CR>
    nnoremenu <silent>WinBar.Stack :b vimspector.StackTrace<CR>
    nnoremenu <silent>WinBar.Variables :b vimspector.Variables<CR>
    nnoremenu <silent>WinBar.Watches :b vimspector.Watches<CR>
    b vimspector.Variables
endfunction

augroup MyVimspectorUICustomistaion
  autocmd!
  autocmd User VimspectorUICreated call s:CustomiseUI()
augroup END
