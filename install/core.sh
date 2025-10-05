#!/bin/bash

source ~/.dotfiles/common.sh

coreutils=(
	# Automation & Configuration Management
	"ansible"

	# Development Tools
	"git"
	"gh"
	"cmake"
	"gcc"

	# Shell and Terminal Enhancements
	"bash-completion"
	"tmux"
	"zellij"
	"fzf"
	"tree"
	"lsof"
	"zoxide"

	# System Utilities
	"htop"
	"btop"
	"watch"
	"rsync"
	"gnupg"
	"wget"
	"coreutils"
	"curl"
	"unzip"
	"tty-clock"

	# Data Processing
	"jq"
	"shellcheck"
	"tree-sitter"
)

for util in "${coreutils[@]}"; do
	install_or_update_packages "$util"
done
