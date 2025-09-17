#!/bin/bash

source ~/.dotfiles/common.sh

install_grip() {
	if [[ "$PLATFORM_NAME" == "mac" ]]; then
		# Try Homebrew first (cleanest approach)
		echo "Installing grip via Homebrew..."
		install_or_update_package grip
		
		# Verify installation
		if command -v grip &> /dev/null; then
			echo "Grip installed successfully via Homebrew:"
			grip --version
		else
			echo "Homebrew installation failed, trying pipx as fallback..."
			install_grip_pipx
		fi

	elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
		echo "Installing grip via pipx on Ubuntu..."
		install_grip_pipx
	fi
}

install_grip_pipx() {
	# Ensure pipx is available
	if ! command -v pipx &> /dev/null; then
		echo "Installing pipx first..."
		if [[ "$PLATFORM_NAME" == "mac" ]]; then
			install_or_update_package pipx
		elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
			sudo apt-get update
			sudo apt-get install -y python3-pip python3-venv
			python3 -m pip install --user pipx
			python3 -m pipx ensurepath
		fi
	fi
	
	# Install grip via pipx (isolated environment)
	echo "Installing grip via pipx..."
	pipx install grip
	
	# Verify installation
	if command -v grip &> /dev/null; then
		echo "Grip installed successfully via pipx:"
		grip --version
	else
		echo "Error: Grip installation failed. Please check your Python setup."
		return 1
	fi
}

test_grip_installation() {
	echo "Testing grip installation..."
	
	if ! command -v grip &> /dev/null; then
		echo "Error: grip command not found in PATH"
		return 1
	fi
	
	# Create test markdown file with mermaid diagram
	local test_dir="/tmp/grip-test"
	local test_file="$test_dir/test.md"
	
	mkdir -p "$test_dir"
	cat > "$test_file" << 'EOF'
# Grip Test

This is a test markdown file to verify grip functionality.

## Mermaid Diagram Test

```mermaid
graph TD
    A[Start] --> B{Is grip working?}
    B -->|Yes| C[Success!]
    B -->|No| D[Debug needed]
    C --> E[End]
    D --> E
```

## Features Test

- [x] Basic markdown rendering
- [x] Mermaid diagram support
- [x] GitHub-accurate styling
- [x] Live reload functionality

**Bold text** and *italic text* should render correctly.

`Code blocks` and:

```bash
#!/bin/bash
echo "Syntax highlighting test"
```

> Blockquote test

| Table | Test |
|-------|------|
| Cell 1| Cell 2|
EOF

	echo "Test file created at: $test_file"
	echo "You can test grip manually with:"
	echo "  grip '$test_file' --browser"
	echo "This should open your browser at http://localhost:6419"
	
	# Cleanup
	rm -rf "$test_dir"
	
	return 0
}

uninstall_grip() {
	if [[ "$PLATFORM_NAME" == "mac" ]]; then
		if is_package_installed "grip"; then
			echo "Uninstalling grip via Homebrew..."
			brew uninstall grip
		elif command -v pipx &> /dev/null && pipx list | grep -q "grip"; then
			echo "Uninstalling grip via pipx..."
			pipx uninstall grip
		else
			echo "Grip is not installed via Homebrew or pipx."
		fi
	elif [[ "$PLATFORM_NAME" == "ubuntu" ]]; then
		if command -v pipx &> /dev/null && pipx list | grep -q "grip"; then
			echo "Uninstalling grip via pipx..."
			pipx uninstall grip
		else
			echo "Grip is not installed via pipx."
		fi
	fi
}

# Parse command line arguments
case "$1" in
	"--uninstall")
		uninstall_grip
		;;
	"--test")
		test_grip_installation
		;;
	*)
		install_grip
		test_grip_installation
		;;
esac