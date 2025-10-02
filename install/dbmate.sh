#!/bin/bash

source ~/.dotfiles/common.sh

# DBMate is a database migration tool that supports SQLite, MySQL, and PostgreSQL.
# https://github.com/amacneil/dbmate

if [[ "$PLATFORM_NAME" == "mac" ]]; then
	install_or_update_package "dbmate"
elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
	echo "Ubuntu installation for dbmate not implemented yet."
	# TODO: Implement Ubuntu Installation
	# sudo curl -fsSL -o /usr/local/bin/dbmate https://github.com/amacneil/dbmate/releases/latest/download/dbmate-linux-amd64
	# sudo chmod +x /usr/local/bin/dbmate
fi
