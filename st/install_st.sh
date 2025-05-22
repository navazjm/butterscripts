#!/bin/bash

# ============================================
# JustAGuy Linux - ST Terminal Installer
# https://github.com/drewgrif
# ============================================

set -e  # Exit on error

# ASCII Art Banner
clear
echo "
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |j|u|s|t|a|g|u|y|l|i|n|u|x| 
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |s|t| |t|e|r|m|i|n|a|l| | |  
 +-+-+-+-+-+-+-+-+-+-+-+-+-+                                                                            
"

# Configuration variables
ST_REPO="https://github.com/drewgrif/dwm-setup.git"
TEMP_DIR="/tmp/st-terminal-$(date +%s)"
CONFIG_DIR="$HOME/.config/suckless/st"
LOG_FILE="$HOME/st-terminal-install.log"

# Setup logging
exec > >(tee -a "$LOG_FILE") 2>&1
echo "Installation started at $(date)"

# Error handling function
die() {
    echo "ERROR: $*" >&2
    echo "Check log file at $LOG_FILE for details"
    exit 1
}

# Cleanup function
cleanup() {
    echo "Cleaning up temporary files..."
    rm -rf "$TEMP_DIR"
    echo "Cleanup completed."
}
trap cleanup EXIT

# Check for required dependencies
check_dependencies() {
    echo "Checking dependencies..."
    dependencies=("git" "make" "gcc" "pkgconf" "libx11-dev" "libxft-dev" "libxinerama-dev")
    missing=()
    
    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" &> /dev/null && ! dpkg -l | grep -q "$dep"; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo "Missing dependencies: ${missing[*]}"
        read -p "Would you like to install them now? (y/n) " install_deps
        if [[ "$install_deps" =~ ^[Yy]$ ]]; then
            sudo apt-get update
            sudo apt-get install -y "${missing[@]}" || die "Failed to install dependencies"
        else
            die "Missing dependencies. Please install them and try again."
        fi
    fi
    
    echo "All dependencies are installed."
}

# Confirm user intention
confirm_installation() {
    echo "This script will install the ST terminal from drewgrif's repository."
    echo "It will be installed in $CONFIG_DIR and built from source."
    read -p "Do you want to continue? (y/n) " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Installation aborted."
        exit 0
    fi
}

# Check for existing installation
check_existing() {
    if [ -d "$CONFIG_DIR" ]; then
        echo "An existing ST terminal configuration was found at $CONFIG_DIR."
        read -p "Would you like to back it up before proceeding? (y/n) " backup
        if [[ "$backup" =~ ^[Yy]$ ]]; then
            backup_dir="${CONFIG_DIR}_backup_$(date +%Y-%m-%d_%H-%M-%S)"
            mv "$CONFIG_DIR" "$backup_dir" || die "Failed to create backup"
            echo "Backup created at $backup_dir"
        else
            read -p "Would you like to remove the existing configuration? (y/n) " remove
            if [[ "$remove" =~ ^[Yy]$ ]]; then
                rm -rf "$CONFIG_DIR" || die "Failed to remove existing configuration"
                echo "Existing configuration removed."
            else
                die "Cannot proceed with existing configuration in place. Aborting."
            fi
        fi
    fi
}

# Clone repository
clone_repo() {
    echo "Cloning repository: $ST_REPO"
    mkdir -p "$TEMP_DIR"
    git clone "$ST_REPO" "$TEMP_DIR" || die "Failed to clone repository"
    
    # Check if the st directory exists in the cloned repository
    if [ ! -d "$TEMP_DIR/suckless/st" ]; then
        die "ST terminal directory not found in the cloned repository. Expected path: $TEMP_DIR/suckless/st"
    fi
    
    echo "Repository cloned successfully."
}

# Install ST terminal
install_st() {
    # Create suckless config directory
    mkdir -p "$HOME/.config/suckless"
    
    # Copy the st directory to .config/suckless/
    echo "Copying ST terminal to $CONFIG_DIR..."
    cp -r "$TEMP_DIR/suckless/st" "$HOME/.config/suckless/" || die "Failed to copy ST terminal to config directory"
    
    # Navigate to the st directory and compile
    cd "$CONFIG_DIR" || die "Failed to enter ST terminal directory"
    
    echo "Compiling ST terminal..."
    make clean 2>/dev/null || echo "Warning: make clean failed, continuing..."
    make || die "Failed to compile ST terminal"
    
    echo "Installing ST terminal..."
    sudo make install || die "Failed to install ST terminal"
    
    echo "ST terminal installation completed successfully."
}

# Print installation summary
print_summary() {
    echo "============================================"
    echo "          ST Terminal Installation          "
    echo "============================================"
    echo "Installation completed successfully!"
    echo "Source location: $CONFIG_DIR"
    echo "Binary location: /usr/local/bin/st"
    echo "You can now run 'st' to start the terminal."
    echo "============================================"
}

# Main execution
confirm_installation
check_dependencies
check_existing
clone_repo
install_st
print_summary

exit 0
