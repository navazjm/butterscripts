#!/usr/bin/env bash

# ============================================
# Install Wezterm
# ============================================

set -e

die() {
    echo "$1"
    exit 1
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

install_wezterm() {
    if command_exists wezterm; then
        echo "Wezterm is already installed. Skipping installation."
        return
    fi

    echo "Installing Wezterm..."

    WEZTERM_URL="https://github.com/wezterm/wezterm/releases/download/20240203-110809-5046fc22/wezterm-20240203-110809-5046fc22.Debian12.deb"
    TMP_DEB="/tmp/wezterm.deb"

    wget -O "$TMP_DEB" "$WEZTERM_URL" || die "Failed to download Wezterm."
    sudo apt install -y "$TMP_DEB" || die "Failed to install Wezterm."
    rm -f "$TMP_DEB"

    echo "Setting up Wezterm configuration..."
    mkdir -p "$HOME/.config/wezterm"
    wget -O "$HOME/.config/wezterm/wezterm.lua" "https://raw.githubusercontent.com/drewgrif/jag_dots/main/.config/wezterm/wezterm.lua" || die "Failed to download wezterm config."

    echo "Wezterm installation and configuration complete."
}

install_wezterm
