syntax on

" Set the curson for xterm
if &term == "xterm-256color"
  " 1 or 0 -> blinking block
  " 3 -> blinking underscore
  " 5 -> blinking vertical bar
  " 6 -> solid vertical bar
    let &t_SI = "\e[6 q"
    let &t_EI = "\e[2 q"
endif

let g:gruvbox_contrast_dark='medium'
let g:gruvbox_bold=0
let g:gruvbox_invert_signs=0

set termguicolors
set background=dark
colorscheme gruvbox
