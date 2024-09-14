#!/bin/bash

source ~/.dotfiles/common.sh

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
	"unzip"

	# Data Processing
	"jq"
	"shellcheck"
)

for util in "${coreutils[@]}"; do
	install_or_update_packages "$util"
done
