syntax on

if has('termguicolors')
    set termguicolors
    colorscheme gruvbox
    set background=dark
else
    set notermguicolors
    colorscheme evening
endif

let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

if &term == "xterm-256color"
    hi Normal guibg=NONE ctermbg=NONE
endif

if &term == "alacritty"
    hi Normal guibg=NONE ctermbg=NONE
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
