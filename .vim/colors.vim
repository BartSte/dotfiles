syntax on

" Set the curson for xterm
if &term == "xterm-256color"
    let &t_SI = "\e[6 q"
    let &t_EI = "\e[2 q"
endif

if &term =~ 'win32'
  let &t_SI .= "\<Esc>[6 q"
  let &t_EI .= "\<Esc>[2 q"
  " 1 or 0 -> blinking block
  " 3 -> blinking underscore
  " 5 -> blinking vertical bar
  " 6 -> solid vertical bar
endif

set termguicolors
set background=dark
colorscheme gruvbox

let g:gruvbox_contrast_dark='medium'
let g:gruvbox_bold=0
