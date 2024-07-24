#!/bin/bash

source ~/.dotfiles/common.sh
sh $DOTMANGR_PLATFORM_DIR/install.sh
sh $DOTMANGR_BASE_DIR/install/vault.sh
sh $DOTMANGR_BASE_DIR/install/dots.sh
