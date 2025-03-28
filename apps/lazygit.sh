#!/bin/bash

# Install Lazygit (latest release)

# Determine latest Lazygit release
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "\K[^"]*')

# Download the binary (Linux x86_64)
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"

# Extract the binary
tar xf lazygit.tar.gz lazygit

# Move binary to /usr/local/bin (may prompt for password)
sudo install lazygit /usr/local/bin

# Clean up
rm lazygit lazygit.tar.gz

# Check installation
lazygit --version

echo "Lazygit version ${LAZYGIT_VERSION} installed successfully!"
