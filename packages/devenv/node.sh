
#!/bin/bash

source ~/.dotfiles/common.sh

if command -v asdf &> /dev/null; then
	install_asdf_plugin nodejs
	install_asdf_package_version nodejs

	curl -fsSL https://get.pnpm.io/install.sh | sh -
else
	echo "ASDF is Required for node version installation"
fi


