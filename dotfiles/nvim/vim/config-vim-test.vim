" When running WSL and a venv is present in g:wsl_win_venvs, it will take
" presedence over $VIRTUAL_ENV.
function! GetVenv()
    let directory = fnamemodify(getcwd(), ':t')
    let wsl_win_venv = g:wsl_win_venvs . directory
    if isdirectory(wsl_win_venv)
        return wsl_win_venv
    else 
        return $VIRTUAL_ENV
    endif
endfunction

" Retruns the test command that corresponds to the WSL, WSL+windows, or linux
" venv.
function! GetCommand(venv, cmd)
    if a:venv == ''
        return a:cmd
    elseif has('win32')
        return a:venv . '\Scripts\' . a:cmd    
    elseif a:venv==$VIRTUAL_ENV
        return a:venv . '/bin/' . a:cmd    
    else
        let python_exe_cmd = substitute(a:cmd, '^\python\+\s', 'python.exe ', '')
        return a:venv . '/Scripts/' . python_exe_cmd 
    endif
endfunction

" Test strategy that can run tests for Linux projects and Windows projects
" that are edited from WSL.
function! FloatermStrategy(cmd)
    let venv = GetVenv()
    let command = GetCommand(venv, a:cmd)
    execute 'FloatermToggle vimtest'
    execute 'FloatermSend --name=vimtest ' . command
    stopinsert
endfunction

let g:test#strategy = 'myfloaterm'
let g:wsl_win_venvs = expand('$WH/venvs/')
let test#python#runner = 'pytest'
let g:test#custom_strategies = {'myfloaterm': function('FloatermStrategy')}

noremap gl :TestVisit<CR>
noremap <a-t> :TestNearest<CR>
noremap <a-l> :TestLast<CR>
noremap <a-f> :TestFile<CR>
