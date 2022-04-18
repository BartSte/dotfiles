PROMPT_COMMAND='echo -en "\033]0;$(hostname) @ $(pwd)\a"'
export PS1="\[\033[38;5;2m\]\\$\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;6m\]\W\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;1m\]>\[$(tput sgr0)\] \[$(tput sgr0)\]"

alias base='/usr/bin/git --git-dir=$HOME/dotfiles.git/ --work-tree=$HOME'
alias lin='/usr/bin/git --git-dir=$HOME/dotfiles-linux.git/ --work-tree=$HOME'

function gvims () {
    gvim -S $1 -c source ~/.vimrc| source ~/.gvimrc
}
