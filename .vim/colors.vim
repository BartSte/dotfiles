syntax on

" Set the curson for xterm
if &term =~ "xterm-256color\\|screen-256color"
    if exists('$TMUX')
        let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
        let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
    else
        let &t_SI = "\e[5 q"
        let &t_EI = "\e[2 q"
    endif
endif

set termguicolors
colorscheme ayu

"TODO ayu only works with true colors. Approximating it with CSApprox does not
"work well. TMUX is console says it supports 256 but in reality does not. Buttom
"line, find good solutions without hacking colorschemes or using CSApprox as
"the latter will break certains highlihgting things. The problem is:
"highlihgting with tmux screens. Use termguicolors as base line, and build
"execption on top of them.
