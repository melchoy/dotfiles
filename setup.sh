#!/bin/bash
source ~/.dotfiles/common.sh

do_install() {
	sh $DOTMANGR_PLATFORM_DIR/install.sh
	sh $DOTMANGR_BASE_DIR/install/vault.sh
	sh $DOTMANGR_BASE_DIR/install/dots.sh
}

do_uninstall () {
	sh $DOTMANGR_PLATFORM_DIR/uninstall.sh
	sh $DOTMANGR_BASE_DIR/install/dots.sh --uninstall
}

if [ "$1" == "--uninstall" ]; then
	do_uninstall
else
	do_install 
fi
