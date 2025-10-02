#!/bin/bash

source ~/.dotfiles/common.sh

echo "Installing ngrok..."

TOKEN_FILE="$HOME/.vault/secrets/tokens/ngrok.txt"
NGROK_AUTH_TOKEN=$($HOME/.vault/ev view "$TOKEN_FILE")

if [ -z "$NGROK_AUTH_TOKEN" ]; then
  echo "Failed to retrieve ngrok token or token is empty."
  exit 1
fi

if [[ "$PLATFORM_NAME" == "mac" ]]; then
	install_or_update_package "ngrok/ngrok/ngrok"
elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
	echo "Ubuntu installation for ngrok not implemented yet."
	#curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
	#| sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
	#&& echo "deb https://ngrok-agent.s3.amazonaws.com buster main" \
	#| sudo tee /etc/apt/sources.list.d/ngrok.list \
	#&& sudo apt update \
	#&& sudo apt install ngrok
fi

if command -v ngrok &> /dev/null; then
	ngrok config add-authtoken "$NGROK_AUTH_TOKEN"
fi
