#!/bin/bash
set -e
# 00-base.sh: System update and base packages

echo "🔄 Updating system..."
sudo apt clean && sudo apt update && sudo apt upgrade -y

echo "📦 Installing base packages..."
sudo apt install -y \
    git curl build-essential \
    xorg xorg-dev xbacklight xbindkeys xvkbd xinput \
    xdg-user-dirs-gtk \
    cmake meson ninja-build pkg-config \
    network-manager-gnome pamixer dialog \
    mtools avahi-daemon acpi acpid gvfs-backends \
    cifs-utils pipewire-audio unzip
