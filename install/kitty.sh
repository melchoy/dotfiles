#!/bin/zsh

source ~/.dotfiles/common.sh

curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n

symlink_dotfile "$DOTMANGR_CONFIGS_DIR/kitty" "$HOME/.config/kitty"
