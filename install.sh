#!/bin/bash

source ~/.dotfiles/common.sh

# TODO: Create a method to configure the installer to select and install specific packages

do_install() {

	# BOOTSTRAP MACOS PREREQUISITES
	if [[ "$PLATFORM_NAME" == "mac" ]]; then
		sh $DOTMANGR_PLATFORM_DIR/defaults.sh
		sh $DOTMANGR_PLATFORM_DIR/brew.sh
	fi

	# CORE ENVIRONMENT PACKAGES
	sh $DOTMANGR_INSTALLER_DIR/vault.sh
	sh $DOTMANGR_INSTALLER_DIR/zsh.sh
	sh $DOTMANGR_INSTALLER_DIR/nerdfonts.sh
	sh $DOTMANGR_INSTALLER_DIR/starship.sh
	sh $DOTMANGR_INSTALLER_DIR/core.sh
	sh $DOTMANGR_INSTALLER_DIR/tmux.sh
	sh $DOTMANGR_INSTALLER_DIR/zellij.sh

	# PROGRAMMING UTILITIES
	sh $DOTMANGR_INSTALLER_DIR/git.sh
	sh $DOTMANGR_INSTALLER_DIR/lazygit.sh
	sh $DOTMANGR_INSTALLER_DIR/dbmate.sh
	sh $DOTMANGR_INSTALLER_DIR/ngrok.sh
	sh $DOTMANGR_INSTALLER_DIR/grip.sh
	sh "$DOTMANGR_INSTALLER_DIR/helix.sh" "$@"

	# PROGAMMING LANGUAGES & RUNTIMES
	sh $DOTMANGR_INSTALLER_DIR/golang.sh
	sh $DOTMANGR_INSTALLER_DIR/node.sh
	sh $DOTMANGR_INSTALLER_DIR/ruby.sh
	#sh $DOTMANGR_INSTALLER_DIR/deno.sh

	# CODE EDITORS
	sh $DOTMANGR_INSTALLER_DIR/nvim.sh
	sh $DOTMANGR_INSTALLER_DIR/vscode.sh

	# TERMINAL EMULATORS
	sh $DOTMANGR_INSTALLER_DIR/ghostty.sh
	#sh $DOTMANGR_INSTALLER_DIR/kitty.sh
	#sh $DOTMANGR_INSTALLER_DIR/alacritty.sh

	# CLOUD UTILITIES & SDKs
	sh $DOTMANGR_INSTALLER_DIR/gcloud.sh

	# Pulumi
	sh $DOTMANGR_INSTALLER_DIR/pulumi.sh

	# LINKING GENERIC DOTS
	sh $DOTMANGR_INSTALLER_DIR/dots.sh

	# DESKTOP & BROWSER ENVIRONMENT
	# sh $DOTMANGR_INSTALLER_DIR/chromium.sh

	# PLATFORM SPECIFIC DESKTOP APPLICATIONS
	if [[ "$PLATFORM_NAME" == "mac" ]]; then
		sh $DOTMANGR_PLATFORM_DIR/applications.sh
	fi
}

do_uninstall() {
	echo "Do uninstall needs implementing"
}

if [ "$1" == "--uninstall" ]; then
	do_uninstall
else
	do_install
fi
