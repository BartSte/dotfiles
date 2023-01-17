augroup KeepCentered
  autocmd!
  autocmd CursorMoved * normal! zz
  " autocmd TextChangedI * call InsertRecenter()
augroup END

function InsertRecenter() abort
  let at_end = getcursorcharpos()[2] > len(getline('.'))
  normal! zzl
            
  " Fix position of cursor at end of line
  if at_end
    let cursor_pos = getcursorcharpos()
    let cursor_pos[2] = cursor_pos[2] + 1
    call setcursorcharpos(cursor_pos[1:])
  endif
endfunction
