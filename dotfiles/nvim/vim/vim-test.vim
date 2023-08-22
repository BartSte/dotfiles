" See helpers.tslime for more information.
function! TSlimeStrategy(cmd) abort
    call v:lua.require('helpers.tslime').vimtest.python.strategy(a:cmd)
endfunction

" See helpers.tslime for more information.
function! TSlimeStrategyDebug(cmd) abort
    call v:lua.require('helpers.tslime').vimtest.python.strategy_debug(a:cmd)
endfunction

" Vimtest
let g:preserve_screen = 1
let test#python#runner = 'pytest'
let g:test#custom_strategies = {'pytslime': function("TSlimeStrategy"), 'pytslimedebug': function('TSlimeStrategyDebug')}

" Tmux
" Always use the window calld "1" and pane "0" in the current session.
let g:tslime#recievingsession = system('tmux list-panes -t "$TMUX_PANE" -F "#S" | head -n1 | tr -d "\n"')
let g:tslime={'window': '1', 'pane': '0', 'session': g:tslime#recievingsession}

