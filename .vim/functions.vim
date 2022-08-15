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
function! UnitTestStrategy(cmd)
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

" A function that enables deleting a buffer that is currently visible is an
" active window without removing the window. It also ensure there is always 1
" (empty) buffer present to avoid vim from shutting down.
function s:Kwbd(kwbdStage)
  if(a:kwbdStage == 1)
    if(&modified)
      let answer = confirm("This buffer has been modified.  Are you sure you want to delete it?", "&Yes\n&No", 2)
      if(answer != 1)
        return
      endif
    endif
    if(!buflisted(winbufnr(0)))
      bd!
      return
    endif
    let s:kwbdBufNum = bufnr("%")
    let s:kwbdWinNum = winnr()
    windo call s:Kwbd(2)
    execute s:kwbdWinNum . 'wincmd w'
    let s:buflistedLeft = 0
    let s:bufFinalJump = 0
    let l:nBufs = bufnr("$")
    let l:i = 1
    while(l:i <= l:nBufs)
      if(l:i != s:kwbdBufNum)
        if(buflisted(l:i))
          let s:buflistedLeft = s:buflistedLeft + 1
        else
          if(bufexists(l:i) && !strlen(bufname(l:i)) && !s:bufFinalJump)
            let s:bufFinalJump = l:i
          endif
        endif
      endif
      let l:i = l:i + 1
    endwhile
    if(!s:buflistedLeft)
      if(s:bufFinalJump)
        windo if(buflisted(winbufnr(0))) | execute "b! " . s:bufFinalJump | endif
      else
        enew
        let l:newBuf = bufnr("%")
        windo if(buflisted(winbufnr(0))) | execute "b! " . l:newBuf | endif
      endif
      execute s:kwbdWinNum . 'wincmd w'
    endif
    if(buflisted(s:kwbdBufNum) || s:kwbdBufNum == bufnr("%"))
      execute "bd! " . s:kwbdBufNum
    endif
    if(!s:buflistedLeft)
      set buflisted
      set bufhidden=delete
      set buftype=
      setlocal noswapfile
    endif
  else
    if(bufnr("%") == s:kwbdBufNum)
      let prevbufvar = bufnr("#")
      if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != s:kwbdBufNum)
        b #
      else
        bn
      endif
    endif
  endif
endfunction

command! Kwbd call s:Kwbd(1)
nnoremap <silent> <Plug>Kwbd :<C-u>Kwbd<CR>
