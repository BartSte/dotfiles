function! FloatermStrategy(cmd)

    if has('win32') && $VIRTUAL_ENV!=""
        " Used when running from windows
        let command = expand('$VIRTUAL_ENV') . '\Scripts\' . a:cmd

    else
        let directory = fnamemodify(getcwd(), ':t')
        let python_exe_cmd = substitute(a:cmd, '^\python\+\s', 'python.exe ', '')
        let venv = expand('$WH/venvs/') . directory 

        if isdirectory(venv)
            " Used when running from WSL and a venv for windows exists.
            let command = venv . '/Scripts/' . python_exe_cmd
        else
            " Used when running from WSL without windows venv, or Linux
            let command = a:cmd 
        endif

    endif

    execute 'FloatermToggle vimtest'
    execute 'FloatermSend --name=vimtest ' . command
    stopinsert
endfunction

let g:test#custom_strategies = {'myfloaterm': function('FloatermStrategy')}
let g:test#strategy = 'myfloaterm'
let test#python#runner = 'pytest'

noremap gl :TestVisit<CR>
noremap <a-t> :TestNearest<CR>
noremap <a-l> :TestLast<CR>
noremap <a-f> :TestFile<CR>
