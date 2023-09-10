" Tmux
" Always use the window calld "1" and pane "0" in the current session.
let g:tslime_session = system('tmux list-panes -t "$TMUX_PANE" -F "#S" | head -n1 | tr -d "\n"')
let g:tslime_always_current_session = 1
let g:tslime={'window': '1' , 'pane': '0', 'session': g:tslime_session}
