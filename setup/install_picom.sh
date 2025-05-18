#!/bin/bash
set -e
# install-picom-ftlabs.sh: Build and install FT-Labs Picom

# Print current directory for debugging
echo "Current directory: $(pwd)"

# Check if picom is already installed
if command -v picom &>/dev/null; then
    echo "Picom is already installed. Skipping installation."
    exit 0
fi

echo "Installing dependencies for picom..."
sudo apt-get install -y \
    libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev \
    libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev \
    libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev \
    libxcb-dpms0-dev libxcb-glx0-dev libxcb-image0-dev \
    libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev \
    libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev \
    libxcb-xfixes0-dev libxext-dev meson ninja-build uthash-dev

# Create a fixed, unique temp directory
PICOM_BUILD_DIR="/tmp/picom-build-dir"
echo "Creating build directory: $PICOM_BUILD_DIR"

# Remove existing directory if it exists
if [ -d "$PICOM_BUILD_DIR" ]; then
    echo "Removing existing build directory..."
    rm -rf "$PICOM_BUILD_DIR"
fi

mkdir -p "$PICOM_BUILD_DIR"

echo "Cloning FT-Labs picom repository..."
git clone https://github.com/FT-Labs/picom "$PICOM_BUILD_DIR" || {
    echo "Failed to clone FT-Labs Picom."
    exit 1
}

echo "Building picom..."
cd "$PICOM_BUILD_DIR"
meson setup --buildtype=release build
ninja -C build

echo "Installing picom..."
sudo ninja -C build install

echo "Picom installation completed successfully."
