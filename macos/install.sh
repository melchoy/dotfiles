#!/bin/bash

source ~/.dotfiles/macos/common.sh

set -e 

echo "Installing Dev Env for MacOS"

# Run default setup steps
sh $DOTMANGR_PLATFORMSETUP_DIR/defaults.sh

sh $DOTMANGR_PLATFORMSETUP_DIR/brew.sh
sh $DOTMANGR_PLATFORMSETUP_DIR/core-utils.sh

sh $DOTMANGR_PLATFORMSETUP_DIR/zsh.sh
sh $DOTMANGR_PLATFORMSETUP_DIR/applications.sh
