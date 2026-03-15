#!/bin/bash

source ~/.dotfiles/common.sh

do_install() {
	echo "Installing/updating document toolchain (LaTeX, Typst, Pandoc)..."

	if [[ "$PLATFORM_NAME" == "mac" ]]; then
		# MacTeX (full LaTeX distribution) - large download, can take 10+ min
		echo ""
		echo "Installing MacTeX (large download ~4GB, may take several minutes)..."
		brew_install_or_update_cask "mactex"

		echo ""
		echo "Installing Typst..."
		install_or_update_package "typst"

		echo ""
		echo "Installing Pandoc..."
		install_or_update_package "pandoc"

		echo ""
		echo "LaTeX (MacTeX), Typst, and Pandoc are installed."
		echo "Open a new terminal or run: source ~/.zprofile  (so TeX PATH is active)"
	elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
		echo ""
		echo "Installing TeX Live..."
		install_or_update_package "texlive-full"

		echo ""
		echo "Installing Pandoc..."
		install_or_update_package "pandoc"

		echo ""
		echo "Installing Typst..."
		if install_or_update_package "typst" 2>/dev/null; then
			:
		else
			echo "Typst may not be in apt; install from https://github.com/typst/typst/releases if needed."
		fi

		echo ""
		echo "TeX Live, Pandoc, and Typst (if available) are installed."
	else
		echo "Document toolchain install is only supported on macOS and Ubuntu."
		exit 1
	fi

	# Symlink config dirs (all platforms)
	if [[ -d "$DOTMANGR_CONFIGS_DIR/latex" ]]; then
		mkdir -p "$HOME/.config"
		symlink_dotfile "$DOTMANGR_CONFIGS_DIR/latex" "$HOME/.config/latex" 2>/dev/null || true
	fi
	if [[ -d "$DOTMANGR_CONFIGS_DIR/pandoc" ]]; then
		mkdir -p "$HOME/.config"
		symlink_dotfile "$DOTMANGR_CONFIGS_DIR/pandoc" "$HOME/.config/pandoc" 2>/dev/null || true
	fi
	if [[ -d "$DOTMANGR_CONFIGS_DIR/typst" ]]; then
		mkdir -p "$HOME/.config"
		symlink_dotfile "$DOTMANGR_CONFIGS_DIR/typst" "$HOME/.config/typst" 2>/dev/null || true
	fi

	echo "Config templates are in ~/.dotfiles/config/latex, config/typst, and config/pandoc"
}

do_uninstall() {
	echo "Uninstalling document toolchain..."

	if [[ "$PLATFORM_NAME" == "mac" ]]; then
		brew uninstall --cask mactex 2>/dev/null || true
		brew uninstall typst pandoc 2>/dev/null || true
		echo "You may remove the /Library/TeX/texbin line from config/zsh/.zprofile if you no longer use LaTeX."
	elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
		sudo apt-get remove -y texlive-full pandoc typst 2>/dev/null || true
	fi

	echo "Document toolchain uninstalled."
}

if [ "$1" == "--uninstall" ]; then
	do_uninstall
else
	do_install
fi
