function! GTestTmux(cmd) abort
    call v:lua.require('helpers.tmux').send_command(a:cmd)
endfunction

let g:gtest#gtest_runner = function('GTestTmux')
