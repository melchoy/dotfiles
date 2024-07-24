#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Install Homebrew if not installed
if ! command_exists brew; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed."
fi

# Ensure Homebrew is up-to-date
echo "Updating Homebrew..."
brew update

# Install Ansible if not installed
if ! command_exists ansible; then
  echo "Ansible not found. Installing Ansible..."
  brew install ansible
else
  echo "Ansible is already installed."
fi

# Clone the @Config repository
#if [ ! -d "$HOME/Config" ]; then
#    echo "Cloning the @Config repository..."
#    git clone https://github.com/melchoy/config.git "$HOME/@Config"
#else
#    echo "The @Config repository already exists."
#fi

echo "Setup complete. You can now run the Ansible playbook with:"
#echo "cd ./playbooks"
#echo "ansible-playbook -i ../hosts.ini setup.yml"