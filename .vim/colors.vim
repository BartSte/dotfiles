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

if &term == "win32"
    set termguicolors
    let &t_SI="\e[5 q"
    let &t_EI="\e[1 q"
    let g:gruvbox_contrast_dark='medium'
    let g:gruvbox_bold=0
    let g:gruvbox_invert_signs=0
    colorscheme gruvbox
    set background=dark
endif

if &term == "linux"
    set notermguicolors
    colorscheme evening
endif
