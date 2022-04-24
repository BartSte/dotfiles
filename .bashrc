PROMPT_COMMAND='echo -en "\033]0;$(hostname) @ $(pwd)\a"'
export PS1="\[\033[38;5;2m\]\\$\[$(tput sgr0)\] \W \[$(tput sgr0)\]\[\033[38;5;196m\]\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')\[$(tput sgr0)\]\[\033[38;5;2m\]>\[$(tput sgr0)\]"
export FZF_COMPLETION_TRIGGER=''
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ...'
alias ....='cd ....'
alias rm='rm -I'
alias cp='cp -I'
alias mv='mv -I'
alias mkdir='mkdir -p'
alias path='echo -e ${PATH//:/\\n}'
alias base='/usr/bin/git --git-dir=$HOME/dotfiles.git/ --work-tree=$HOME'
alias lin='/usr/bin/git --git-dir=$HOME/dotfiles-linux.git/ --work-tree=$HOME'

alias ls='ls -h --color'
alias lx='ls -lXB' # extension
alias lk='ls -lSr' # size
alias lt='ls -ltr' # date
alias lc='ls -ltcr' # time
alias lu='ls -ltur' # access time
alias ll="ls -lv --group-directories-first" # directories first, alphanumeric sorting:
alias lr='ll -R' # recursive
alias la='ll -A' # hidden

function vims () {
    vim -S $1 -c source ~/.vimrc
}

function gvims () {
    gvim -S $1 -c source ~/.vimrc| source ~/.gvimrc
}


[ -f ~/.fzf.bash ] && source ~/.fzf.bash

