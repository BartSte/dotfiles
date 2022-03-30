. ~/dotfiles/config.sh

function set_git_config () {
    git config --global user.name ${git[0]}
    git config --global user.email ${git[1]}
}
