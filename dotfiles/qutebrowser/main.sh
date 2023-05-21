#!/bin/bash

link_qutebrowser_config() {
    echo "Link qutebrowser config"
    source=~/dotfiles/qutebrowser/config.py
    destination=~/.config/qutebrowser/config.py
    rm $destination
    ln $source $destination --symbolic
}

link_qutebrowser_config
