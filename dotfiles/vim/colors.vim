syntax on

if has('termguicolors')
    set termguicolors
    set background=dark
    colorscheme gruvbox
endif

let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"

if &term == "alacritty"
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    hi Normal guibg=NONE ctermbg=NONE
endif
