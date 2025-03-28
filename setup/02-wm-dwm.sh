#!/bin/bash
set -e
# 02-wm-dwm.sh: Set up DWM and suckless components

CONFIG_DIR="$HOME/.config/suckless"

# Get the directory of this script to locate the repo
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"  # assume script is in butterscripts/setup/
CLONED_DIR="$HOME/dwm-setup/config/suckless"  # fallback default

# Try to find the repo root based on where install.sh is being run from
if [ -d "$REPO_ROOT/config/suckless" ]; then
    CLONED_DIR="$REPO_ROOT/config/suckless"
fi

# Check for existing config
check_dwm() {
    if [ -d "$CONFIG_DIR" ]; then
        echo "An existing ~/.config/suckless directory was found."
        read -p "Backup existing configuration? (y/n) " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            backup_dir="$HOME/.config/suckless_backup_$(date +%Y-%m-%d_%H-%M-%S)"
            mv "$CONFIG_DIR" "$backup_dir" || {
                echo "Failed to backup existing config."
                exit 1
            }
            echo "Backup saved to $backup_dir"
        fi
    fi
}

# Ensure /usr/share/xsessions exists and create dwm.desktop
setup_xsession() {
    if [ ! -d /usr/share/xsessions ]; then
        sudo mkdir -p /usr/share/xsessions || {
            echo "Failed to create /usr/share/xsessions. Exiting."
            exit 1
        }
    fi

    cat > /tmp/dwm.desktop << "EOF"
[Desktop Entry]
Encoding=UTF-8
Name=dwm
Comment=Dynamic window manager
Exec=dwm
Icon=dwm
Type=XSession
EOF

    sudo cp /tmp/dwm.desktop /usr/share/xsessions/dwm.desktop
    rm /tmp/dwm.desktop
}

# Copy suckless config and build
setup_dwm_config() {
    mkdir -p "$CONFIG_DIR"

    for dir in dwm st slstatus dunst fonts picom rofi scripts sxhkd wallpaper; do
        if [ -d "$CLONED_DIR/$dir" ]; then
            cp -r "$CLONED_DIR/$dir" "$CONFIG_DIR/" || echo "Warning: Failed to copy $dir."
        fi
    done

    for component in dwm st slstatus; do
        if [ -d "$CONFIG_DIR/$component" ]; then
            cd "$CONFIG_DIR/$component" || {
                echo "Failed to enter $component directory."
                exit 1
            }
            make
            sudo make clean install || echo "Failed to install $component."
        fi
    done
}

# === Run Steps ===
check_dwm
setup_xsession
setup_dwm_config
