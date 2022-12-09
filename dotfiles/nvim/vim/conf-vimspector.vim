let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_install_gadgets = ["debugpy","vscode-cpptools", "debugpy-python2"]

" 1 window for the code, 1 window for the rest.
function! s:CustomiseUI()
    call win_gotoid( g:vimspector_session_windows.code )
    only
    vsplit
    b vimspector.Variables
    set ft=cpp
endfunction

augroup VimspectorUI
  autocmd!
  autocmd User VimspectorUICreated call s:CustomiseUI()
augroup END

noremap <F7> <Plug>VimspectorReset
noremap <silent><a-C> :b vimspector.Console<bar>set ft=cpp<CR>
noremap <silent><a-E> :b vimspector.Output:stderr<bar>set ft=cpp<CR>
noremap <silent><a-A> :b vimspector.StackTrace<bar>set ft=cpp<CR>
noremap <silent><a-V> :b vimspector.Variables<bar>set ft=cpp<CR>
noremap <silent><a-W> :b vimspector.Watches<bar>set ft=cpp<CR>
noremap <silent><a-R> :b vimspector.output:server<bar>set ft=cpp<CR>
noremap <silent><a-P> :VimspectorBreakpoints<bar>set ft=cpp<CR>
