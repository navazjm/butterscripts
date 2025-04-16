#!/usr/bin/env bash
# ============================================
# Install WezTerm - Terminal Emulator
# ============================================
set -e

# Helper functions
die() {
    echo "ERROR: $1"
    exit 1
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main installation function
install_wezterm() {
    if command_exists wezterm; then
        echo "WezTerm is already installed. Skipping installation."
        return
    fi
    
    echo "Installing WezTerm..."
    
    # More descriptive variables
    WEZTERM_VERSION="20240203-110809-5046fc22"
    WEZTERM_FILENAME="wezterm-${WEZTERM_VERSION}.Debian12.deb"
    WEZTERM_URL="https://github.com/wezterm/wezterm/releases/download/${WEZTERM_VERSION}/${WEZTERM_FILENAME}"
    TMP_DEB="/tmp/${WEZTERM_FILENAME}"
    
    # Download and install
    wget -O "$TMP_DEB" "$WEZTERM_URL" || die "Failed to download WezTerm."
    sudo apt install -y "$TMP_DEB" || die "Failed to install WezTerm."
    rm -f "$TMP_DEB"
    
    # Setup configuration
    echo "Setting up WezTerm configuration..."
    CONFIG_DIR="$HOME/.config/wezterm"
    mkdir -p "$CONFIG_DIR"
    
    # Updated configuration URL
    CONFIG_URL="https://github.com/drewgrif/butterscripts/raw/main/wezterm/wezterm.lua"
    wget -O "$CONFIG_DIR/wezterm.lua" "$CONFIG_URL" || die "Failed to download WezTerm config."
    
    echo "WezTerm installation and configuration complete."
}

# Run the installation
install_wezterm
