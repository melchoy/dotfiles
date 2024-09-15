#!/bin/bash

source ~/.dotfiles/common.sh

do_install() {
	# LINKING THE DOTS
	sh $DOTMANGR_PACKAGES_DIR/dots.sh

	# COMMAND LINE STUFF
	if [[ "$PLATFORM_NAME" == "mac" ]]; then
		sh $DOTMANGR_PLATFORM_DIR/defaults.sh
		sh $DOTMANGR_PLATFORM_DIR/brew.sh
	fi

	sh $DOTMANGR_PACKAGES_DIR/vault.sh
	sh $DOTMANGR_PACKAGES_DIR/zsh.sh
	sh $DOTMANGR_PACKAGES_DIR/core.sh

	# PROGRAMMING UTILITIES
	sh $DOTMANGR_PACKAGES_DIR/git.sh
	sh $DOTMANGR_PACKAGES_DIR/asdf.sh
	sh $DOTMANGR_PACKAGES_DIR/neovim.sh

	# DESKTOP STUFF
	if [[ "$PLATFORM_NAME" == "mac" ]]; then
		sh $DOTMANGR_PLATFORM_DIR/applications.sh
	fi
}

do_uninstall () {
	echo "Do uninstall needs implementing"
}

if [ "$1" == "--uninstall" ]; then
	do_uninstall
else
	do_install
fi
