#!/usr/bin/env bash

# ============================================
# Install Fastfetch
# ============================================

set -e

INSTALL_DIR="$HOME/.local/src"

die() {
    echo "$1"
    exit 1
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

install_fastfetch() {
    if command_exists fastfetch; then
        echo "Fastfetch is already installed. Skipping installation."
        return
    fi	

    echo "Installing Fastfetch..."
    mkdir -p "$INSTALL_DIR"
    git clone https://github.com/fastfetch-cli/fastfetch "$INSTALL_DIR/fastfetch" || die "Failed to clone Fastfetch."
    cd "$INSTALL_DIR/fastfetch"
    cmake -S . -B build
    cmake --build build
    sudo mv build/fastfetch /usr/local/bin/
    echo "Fastfetch installation complete."
    
    echo "Setting up Fastfetch configuration..."
    mkdir -p "$HOME/.config/fastfetch"

    git clone --depth=1 --filter=blob:none --sparse "https://github.com/drewgrif/jag_dots.git" "$HOME/tmp_jag_dots"
    cd "$HOME/tmp_jag_dots"
    git sparse-checkout set .config/fastfetch
    mv .config/fastfetch "$HOME/.config/"

    cd && rm -rf "$HOME/tmp_jag_dots"
    echo "Fastfetch configuration setup complete."
}

install_fastfetch
