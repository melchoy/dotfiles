#!/bin/bash

source ~/.dotfiles/common.sh

coreutils=(
	# Automation & Configuration Management
	"ansible"

	# Development Tools
	"git"
	"gh"
	"cmake"

	# Shell and Terminal Enhancements
	"bash-completion"
	"tmux"
	"zellij"
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
	"unzip"

	# Data Processing
	"jq"
	"shellcheck"
	"tree-sitter"
)

for util in "${coreutils[@]}"; do
	install_or_update_packages "$util"
done
