#!/bin/bash

source ~/.dotfiles/common.sh
sh $DOTMANGR_PLATFORM_DIR/uninstall.sh
sh $DOTMANGR_BASE_DIR/install/dots.sh --uninstall
