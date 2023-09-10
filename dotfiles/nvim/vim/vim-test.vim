lua require('helpers.vimtest').setup()

function! PytestTmux(cmd) abort
    call v:lua.require('helpers.vimtest').pytest.strategy(a:cmd)
endfunction

function! PytestTmuxDebug(cmd) abort
    call v:lua.require('helpers.vimtest').pytest.strategy_debug(a:cmd)
endfunction

let g:preserve_screen = 1
let test#python#runner = 'pytest'
let g:test#custom_strategies = {'pytesttmux': function("PytestTmux"), 'pytesttmuxdebug': function('PytestTmuxDebug')}
