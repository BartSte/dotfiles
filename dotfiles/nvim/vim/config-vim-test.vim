function! FloatermStrategy(cmd)
    execute 'FloatermToggle '
    execute 'FloatermSend ' . a:cmd
    stopinsert
endfunction

let g:test#custom_strategies = {'myfloaterm': function('FloatermStrategy')}
let g:test#strategy = 'myfloaterm'
let test#python#runner = 'pytest'

noremap gl :TestVisit<CR>
noremap <a-t> :TestNearest<CR>
noremap <a-l> :TestLast<CR>
noremap <a-f> :TestFile<CR>
