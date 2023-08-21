" Test strategy that can run tests for Linux projects and Windows projects
" that are edited from WSL.
function! TSlimeStrategy(cmd) abort
    let venv = GetVenv()
    let command = GetCommand(venv, a:cmd)
    call SafeSendToTmux(command . "\n")
endfunction

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
        let python_exe_cmd = substitute(a:cmd, '^\python[^ ]\+\s', 'python.exe ', '')
        return a:venv . '/Scripts/' . python_exe_cmd 
    endif
endfunction

function! SafeSendToTmux(cmd) abort
    call Send_to_Tmux("C-c")
    call Send_to_Tmux(a:cmd)
endfunction

" Test strategy that can run tests for Linux projects and Windows projects
" that are edited from WSL.
function! TSlimeStrategyDebug(cmd) abort
    let venv = GetVenv()
    let command = GetCommand(venv, a:cmd)
    call SafeSendToTmux(command . " --pdb --pdbcls=IPython.terminal.debugger:Pdb\n")
endfunction


let g:wsl_win_venvs = expand('$WH/venvs/')
let g:preserve_screen = 1
let test#python#runner = 'pytest'
let g:test#custom_strategies = {'pytslime': function('TSlimeStrategy'), 'pytslimedebug': function('TSlimeStrategyDebug')}

" Always use the window calld "1" and pane "0" in the current session.
let s:session = system('tmux list-panes -t "$TMUX_PANE" -F "#S" | head -n1 | tr -d "\n"')
let g:tslime={'window': '1', 'pane': '0', 'session': s:session}
