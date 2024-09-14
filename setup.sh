#!/bin/bash
source ~/.dotfiles/common.sh

do_install() {

	# COMMAND LINE STUFF

	if [[ "$PLATFORM_NAME" == "mac" ]]; then
		sh $DOTMANGR_PLATFORM_INSTALL_DIR/defaults.sh
		sh $DOTMANGR_PLATFORM_INSTALL_DIR/brew.sh
	fi

	sh $DOTMANGR_INSTALL_DIR/vault.sh
	sh $DOTMANGR_INSTALL_DIR/zsh.sh
	sh $DOTMANGR_INSTALL_DIR/core-utils.sh

	sh $DOTMANGR_INSTALL_DIR/dots.sh

	# DESKTOP STUFF

	if [[ "$PLATFORM_NAME" == "mac" ]]; then
		sh $DOTMANGR_PLATFORM_INSTALL_DIR/applications.sh
	fi
}

do_uninstall () {
	sh $DOTMANGR_PLATFORM_INSTALL_DIR/uninstall.sh
	sh $DOTMANGR_BASE_DIR/install/dots.sh --uninstall
}

if [ "$1" == "--uninstall" ]; then
	do_uninstall
else
	do_install
fi
