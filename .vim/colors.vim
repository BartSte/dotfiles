syntax on

if has('termguicolors')
    set termguicolors
    colorscheme gruvbox
    set background=dark
endif

let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"

if &term == "alacritty"
    hi Normal guibg=NONE ctermbg=NONE
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
