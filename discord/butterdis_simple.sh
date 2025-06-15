#!/bin/bash

set -e

# Define variables
DISCORD_DIR="/opt/Discord"
DISCORD_BIN="/usr/bin/Discord"
DESKTOP_FILE="/usr/share/applications/discord.desktop"
TAR_URL="https://discord.com/api/download?platform=linux&format=tar.gz"
TAR_FILE="discord.tar.gz"

# Function to install or update Discord
install_discord() {
    echo "Installing/updating Discord..."
    
    # Download latest Discord
    echo "Downloading latest Discord..."
    if command -v wget >/dev/null 2>&1; then
        wget "$TAR_URL" -O "$TAR_FILE"
    elif command -v curl >/dev/null 2>&1; then
        curl -L "$TAR_URL" -o "$TAR_FILE"
    else
        echo "Error: Neither wget nor curl is installed." >&2
        exit 1
    fi
    
    # Remove old installation if exists
    if [ -d "$DISCORD_DIR" ] || [ -f "$DISCORD_BIN" ]; then
        echo "Removing old Discord installation..."
        sudo rm -rf "$DISCORD_DIR"
        sudo rm -f "$DISCORD_BIN"
    fi
    
    # Extract and install
    echo "Extracting files..."
    sudo tar -xf "$TAR_FILE" -C /opt/
    rm "$TAR_FILE"
    
    # Create symlink
    echo "Creating symlink..."
    sudo ln -sf "$DISCORD_DIR/Discord" "$DISCORD_BIN"
    
    # Create desktop entry
    echo "Creating desktop entry..."
    sudo bash -c 'cat > '"$DESKTOP_FILE"' << EOF
[Desktop Entry]
Name=Discord
StartupWMClass=discord
Comment=All-in-one voice and text chat
GenericName=Internet Messenger
Exec=/usr/bin/Discord
Icon=/opt/Discord/discord.png
Type=Application
Categories=Network;InstantMessaging;
Path=/usr/bin
EOF'
    
    echo "Discord installation complete."
}

# Function to uninstall Discord
uninstall_discord() {
    echo "Uninstalling Discord..."
    sudo rm -rf "$DISCORD_DIR"
    sudo rm -f "$DISCORD_BIN"
    sudo rm -f "$DESKTOP_FILE"
    echo "Discord has been uninstalled."
}

# Show help message
show_help() {
    echo "Butter Discord - Simple Discord installer for Linux"
    echo ""
    echo "Usage: $(basename $0) [option]"
    echo ""
    echo "Options:"
    echo "  install    Install or update Discord"
    echo "  uninstall  Remove Discord"
    echo "  help       Show this help message"
    echo ""
    echo "If no option is provided, the script will install/update Discord."
}

# Main script logic
case "$1" in
    install|update|"")
        install_discord
        ;;
    uninstall)
        uninstall_discord
        ;;
    help|-h|--help)
        show_help
        ;;
    *)
        echo "Unknown option: $1"
        show_help
        exit 1
        ;;
esac

exit 0
