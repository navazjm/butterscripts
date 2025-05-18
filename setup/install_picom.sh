#!/bin/bash
set -e
# install-picom-ftlabs.sh: Build and install FT-Labs Picom

if command -v picom &>/dev/null; then
    echo "Picom is already installed. Skipping installation."
    exit 0
fi

sudo apt-get install -y \
    libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev \
    libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev \
    libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev \
    libxcb-dpms0-dev libxcb-glx0-dev libxcb-image0-dev \
    libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev \
    libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev \
    libxcb-xfixes0-dev libxext-dev meson ninja-build uthash-dev

# Create a subdirectory specifically for picom to avoid conflicts
PICOM_DIR="${INSTALL_DIR:-/tmp/install-picom}/picom-build"
mkdir -p "$PICOM_DIR"

git clone https://github.com/FT-Labs/picom "$PICOM_DIR" || {
    echo "Failed to clone FT-Labs Picom."
    exit 1
}

cd "$PICOM_DIR"
meson setup --buildtype=release build
ninja -C build
sudo ninja -C build install
