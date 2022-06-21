syntax on

if &term == "xterm-256color"
    let &t_SI = "\e[6 q"
    let &t_EI = "\e[2 q"
    source ~/.vim/colorscheme.vim
endif

if &term == "alacritty"
    let &t_SI = "\e[6 q"
    let &t_EI = "\e[2 q"
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    source ~/.vim/colorscheme.vim
endif

if &term == "linux"
    set notermguicolors
    colorscheme evening
endif
