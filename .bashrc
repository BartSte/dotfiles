PROMPT_COMMAND='echo -en "\033]0;$(hostname) @ $(pwd)\a"'
export PS1="\[\033[38;5;2m\]\\$\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;6m\]\W\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;1m\]>\[$(tput sgr0)\] \[$(tput sgr0)\]"

alias base='/mingw64/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias win='/mingw64/bin/git --git-dir=$HOME/.dotfiles-windows/ --work-tree=$HOME'
