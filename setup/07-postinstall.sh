#!/bin/bash
set -e
# 07-postinstall.sh: Post-install cleanup and user setup

# Enable common system services
enable_services() {
    sudo systemctl enable avahi-daemon || echo "Warning: Failed to enable avahi-daemon."
    sudo systemctl enable acpid || echo "Warning: Failed to enable acpid."
}

# Set up user directories
setup_user_dirs() {
    xdg-user-dirs-update
    mkdir -p ~/Screenshots/
}

enable_services
setup_user_dirs
