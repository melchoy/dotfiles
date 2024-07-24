#!/bin/bash

source ~/.dotfiles/macos/common.sh

set -e  # Exit script if any command fails

echo "Installing Core Utils"

coreutils=(
	# Automation & Configuration Management
	"ansible"

	# Development Tools
	"git"
	"gh"

	# Shell and Terminal Enhancements
	"bash-completion"
	"tmux"
	"fzf"
	"tree"
	"lsof"

	# System Utilities
	"htop"
	"watch"
	"rsync"
	"gnupg"
	"wget"
	"coreutils" 
	"curl"

	# Data Processing
	"jq"
	"shellcheck"  
)

for util in "${coreutils[@]}"; do
	brew_install_or_update "$util"
done
