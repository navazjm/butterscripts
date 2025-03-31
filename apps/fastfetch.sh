#!/bin/bash
set -e
# fastfetch.sh: Install and configure Fastfetch

command_exists() {
    command -v "$1" &>/dev/null
}

read -p "Install Fastfetch? (y/n): " confirm
[[ ! "$confirm" =~ ^[Yy]$ ]] && {
    echo "Skipping Fastfetch."
    exit 0
}

INSTALL_DIR="${INSTALL_DIR:-/tmp/install-fastfetch}"
mkdir -p "$INSTALL_DIR"

if command_exists fastfetch; then
    echo "Fastfetch is already installed. Skipping build."
else
    echo "Building Fastfetch..."
    git clone https://github.com/fastfetch-cli/fastfetch "$INSTALL_DIR/fastfetch"
    cd "$INSTALL_DIR/fastfetch"
    cmake -S . -B build
    cmake --build build
    sudo mv build/fastfetch /usr/local/bin/
    echo "Fastfetch installed."
fi

echo "Setting up Fastfetch config..."
mkdir -p "$HOME/.config/fastfetch"
curl -fsSL https://raw.githubusercontent.com/drewgrif/jag_dots/main/.config/fastfetch/config.json \
    -o "$HOME/.config/fastfetch/config.json"

echo "Fastfetch configuration complete."
