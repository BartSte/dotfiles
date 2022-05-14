PROMPT_COMMAND='echo -en "\033]0;$(hostname) @ $(pwd)\a"'
export PS1="\[\033[38;5;2m\]\\$\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;51m\]\W\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;172m\]\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')\[$(tput sgr0)\]>\[$(tput sgr0)\]"

export FZF_DEFAULT_COMMAND='ag --hidden --skip-vcs-ignores --path-to-ignore '"$HOME"'/.ignore -g . '"$HOME"'' 
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_COMPLETION_TRIGGER=''
export FZF_ALT_C_COMMAND='find -type d -not -path "*.git*"'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ...'
alias ....='cd ....'
alias path='echo -e ${PATH//:/\\n}'
alias base='/usr/bin/git --git-dir=$HOME/dotfiles.git/ --work-tree=$HOME'
alias lin='/usr/bin/git --git-dir=$HOME/dotfiles-linux.git/ --work-tree=$HOME'
alias bat=batcat

alias ls='ls -h --color'
alias la='ls -A' 
alias ll='ls -l'
alias lal='ls -Al'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
