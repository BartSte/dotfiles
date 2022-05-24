syntax on

" Set the curson for xterm
if &term == "xterm"
    let &t_SI = "\<Esc>]12;white\x7"
    let &t_EI = "\<Esc>]12;white\x7"
    silent !echo -ne "\033]12;white\007"
    autocmd VimLeave * silent !echo -ne "\033]112\007"
    let &t_SI .= "\<Esc>[5 q"
    let &t_EI .= "\<Esc>[0 q"
endif

if &t_Co >= 256
    set termguicolors
    colorscheme ayu
endif
