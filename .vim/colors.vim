syntax on

" Set the curson for xterm
if &term == "xterm-256color"
    let &t_SI = "\e[6 q"
    let &t_EI = "\e[2 q"
    set termguicolors
    set background=dark
    let g:gruvbox_contrast_dark='medium'
    let g:gruvbox_bold=0
endif

if &term == "alacritty"
    let &t_SI = "\e[6 q"
    let &t_EI = "\e[2 q"
    set notermguicolors
    set background=dark
    let g:gruvbox_contrast_dark='medium'
    let g:gruvbox_bold=0
endif

if &term == "linux"
    set notermguicolors
    colorscheme evening
endif
