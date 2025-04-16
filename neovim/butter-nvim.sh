#!/bin/bash
# butter-nvim.sh: Install JustAGuyLinux Neovim Configuration
# -----------------------------------------------------------

set -e  # Exit immediately if a command exits with a non-zero status

# Display welcome banner
echo "==============================================="
echo "  ButterScripts: JustAGuyLinux Neovim Setup   "
echo "==============================================="
echo "This script will install the JustAGuyLinux Neovim"
echo "configuration and set up everything for you."
echo

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "🔍 Git is not installed. Installing git..."
    sudo apt update
    sudo apt install -y git
fi

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Clone the repository
echo "🔄 Cloning JustAGuyLinux Neovim repository..."
git clone https://github.com/drewgrif/nvim.git

# Install the Debian package
echo "📦 Installing Neovim Debian package..."
if [ -f "nvim/nvim-linux64.deb" ]; then
    sudo dpkg -i nvim/nvim-linux64.deb
    # Install dependencies if the dpkg command failed
    if [ $? -ne 0 ]; then
        echo "🔧 Fixing dependencies..."
        sudo apt --fix-broken install -y
        sudo dpkg -i nvim/nvim-linux64.deb
    fi
else
    echo "❌ Error: Neovim Debian package not found in the repository."
    exit 1
fi

# Back up existing Neovim configuration if it exists
NVIM_CONFIG_DIR="$HOME/.config/nvim"
if [ -d "$NVIM_CONFIG_DIR" ]; then
    echo "💾 Backing up existing Neovim configuration..."
    BACKUP_DIR="$HOME/.config/nvim_backup_$(date +%Y%m%d%H%M%S)"
    mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
    echo "✅ Existing configuration backed up to $BACKUP_DIR"
fi

# Create the Neovim configuration directory
mkdir -p "$NVIM_CONFIG_DIR"

# Copy configuration files
echo "🔧 Setting up ButterScripts Neovim configuration..."
cp -r nvim/* "$NVIM_CONFIG_DIR/"

# Clean up
echo "🧹 Cleaning up temporary files..."
cd
rm -rf "$TEMP_DIR"

echo
echo "✨ Installation complete! ✨"
echo "When you first start Neovim, it will automatically install all required packages."
echo
echo "Start your new ButterScripts Neovim by running: nvim"
echo "==============================================="
