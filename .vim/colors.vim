syntax on

" Set the curson for xterm
if &term == "xterm-256color"
    let &t_SI = "\e[5 q"
    let &t_EI = "\e[2 q"
endif

set termguicolors
set background=dark
colorscheme gruvbox

let g:gruvbox_contrast_dark='medium'
