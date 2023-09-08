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
