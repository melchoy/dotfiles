
#!/bin/bash

source ~/.dotfiles/common.sh

if command -v asdf &> /dev/null; then
	install_asdf_plugin nodejs
	install_asdf_package_version nodejs

	if ! command -v pnpm &> /dev/null; then
    echo "pnpm not found, installing..."
    curl -fsSL https://get.pnpm.io/install.sh | sh -
  fi
else
	echo "ASDF is Required for node version installation"
fi
