function! FloatermStrategy(cmd)

    if has('win32') && $VIRTUAL_ENV!=""
        let venv = expand('$VIRTUAL_ENV') . '\Scripts\'
    else
        let venv = '' "Linux sets venv automatically
    endif

    execute 'FloatermToggle vimtest'
    execute 'FloatermSend --name=vimtest ' . venv . a:cmd
    stopinsert
endfunction

let g:test#custom_strategies = {'myfloaterm': function('FloatermStrategy')}
let g:test#strategy = 'myfloaterm'
let test#python#runner = 'pytest'

noremap gl :TestVisit<CR>
noremap <a-t> :TestNearest<CR>
noremap <a-l> :TestLast<CR>
noremap <a-f> :TestFile<CR>
