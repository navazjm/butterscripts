#!/bin/bash

# Define variables
SCRIPT_NAME="butter-discord"
LOCAL_BIN_DIR="$HOME/.local/bin"
DISCORD_DIR="/opt/Discord"
DISCORD_BIN="/usr/bin/Discord"
DESKTOP_FILE="/usr/share/applications/discord.desktop"
TAR_FILE="discord.tar.gz"

# Function to create user bin directory and ensure it's in PATH
setup_user_environment() {
    echo "Setting up user environment..."
    
    # Create local bin directory if it doesn't exist
    mkdir -p "$LOCAL_BIN_DIR"
    
    # Copy this script to the bin directory
    SCRIPT_PATH="$(readlink -f "$0")"
    if [ "$SCRIPT_PATH" != "$LOCAL_BIN_DIR/$SCRIPT_NAME" ]; then
        cp "$SCRIPT_PATH" "$LOCAL_BIN_DIR/$SCRIPT_NAME"
        chmod +x "$LOCAL_BIN_DIR/$SCRIPT_NAME"
        echo "Installed $SCRIPT_NAME to $LOCAL_BIN_DIR"
    fi
    
    # Detect shell and update PATH if needed
    CURRENT_SHELL="$(basename "$SHELL")"
    PATH_ENTRY="export PATH=\"\$HOME/.local/bin:\$PATH\""
    FISH_PATH_ENTRY="set -x PATH \$HOME/.local/bin \$PATH"
    
    case "$CURRENT_SHELL" in
        bash)
            CONFIG_FILE="$HOME/.bashrc"
            if ! grep -q "$LOCAL_BIN_DIR" "$CONFIG_FILE" 2>/dev/null; then
                echo "$PATH_ENTRY" >> "$CONFIG_FILE"
                echo "Updated $CONFIG_FILE with PATH entry"
            fi
            ;;
        zsh)
            CONFIG_FILE="$HOME/.zshrc"
            if ! grep -q "$LOCAL_BIN_DIR" "$CONFIG_FILE" 2>/dev/null; then
                echo "$PATH_ENTRY" >> "$CONFIG_FILE"
                echo "Updated $CONFIG_FILE with PATH entry"
            fi
            ;;
        fish)
            CONFIG_FILE="$HOME/.config/fish/config.fish"
            mkdir -p "$(dirname "$CONFIG_FILE")"
            if ! grep -q "$LOCAL_BIN_DIR" "$CONFIG_FILE" 2>/dev/null; then
                echo "$FISH_PATH_ENTRY" >> "$CONFIG_FILE"
                echo "Updated $CONFIG_FILE with PATH entry"
            fi
            ;;
        *)
            echo "Unrecognized shell: $CURRENT_SHELL"
            echo "Please manually add $LOCAL_BIN_DIR to your PATH"
            ;;
    esac
    
    echo "Environment setup complete. You can now run 'butter-discord' from anywhere."
    echo "NOTE: You may need to restart your terminal or run 'source $CONFIG_FILE'"
}

# Function to clean up old Discord installation
cleanup() {
    echo "Cleaning up old Discord installation..."
    sudo rm -rf "$DISCORD_DIR"
    sudo rm -f "$DISCORD_BIN"
    sudo rm -f "$DESKTOP_FILE"
}

# Function to install or update Discord
install_discord() {
    echo "Retrieving the latest Discord tar.gz file..."
    wget "https://discord.com/api/download?platform=linux&format=tar.gz" -O "$TAR_FILE"
    
    echo "Extracting files to /opt directory..."
    sudo tar -xvf "$TAR_FILE" -C /opt/
    rm "$TAR_FILE"
    
    echo "Creating symbolic link..."
    sudo ln -sf "$DISCORD_DIR/Discord" "$DISCORD_BIN"
    
    echo "Creating desktop entry..."
    cat > ./temp << "EOF"
[Desktop Entry]
Name=Discord
StartupWMClass=discord
Comment=All-in-one voice and text chat for gamers that's free, secure, and works on both your desktop and phone.
GenericName=Internet Messenger
Exec=/usr/bin/Discord
Icon=/opt/Discord/discord.png
Type=Application
Categories=Network;InstantMessaging;
Path=/usr/bin
EOF
    sudo cp ./temp "$DESKTOP_FILE"
    rm ./temp
    
    echo "Discord installation/update completed."
}

# Function to uninstall Discord
uninstall_discord() {
    cleanup
    echo "Discord has been uninstalled."
}

# Show help message
show_help() {
    echo "Butter Discord - Install, update, and manage Discord on Linux"
    echo ""
    echo "Usage: $SCRIPT_NAME [option]"
    echo ""
    echo "Options:"
    echo "  install    Install or update Discord"
    echo "  uninstall  Remove Discord from your system"
    echo "  setup      Set up this script in your user environment"
    echo "  help       Show this help message"
    echo ""
    echo "If no option is provided, the script will install or update Discord."
}

# Main script logic
case "$1" in
    install|update|"")
        if [ -d "$DISCORD_DIR" ] || [ -f "$DISCORD_BIN" ]; then
            cleanup
        fi
        install_discord
        ;;
    uninstall)
        uninstall_discord
        ;;
    setup)
        setup_user_environment
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
