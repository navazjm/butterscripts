#!/bin/bash

# Main installer script for Butterscripts

# Error handling function
die() {
    echo "ERROR: $1" >&2
    exit 1
}

# Function to download a butterscript
get_butterscript() {
    local script_path="$1"
    local temp_script="/tmp/butterscript_$(basename "$script_path")"
    
    echo "Fetching script: $script_path from butterscripts repository..."
    wget -q -O "$temp_script" "https://raw.githubusercontent.com/drewgrif/butterscripts/main/$script_path" || die "Failed to download script: $script_path"
    chmod +x "$temp_script"
    echo "$temp_script"
}

# Function to run a butterscript
run_butterscript() {
    local script_path="$1"
    local script_file=$(get_butterscript "$script_path")
    echo "Running script: $script_path"
    bash "$script_file" || die "Failed to run script: $script_path"
    rm -f "$script_file"
}

# Function to ask yes/no questions
ask_yes_no() {
    while true; do
        read -p "$1 (y/n): " answer
        case $answer in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done
}

# Welcome message
echo "=== Butterscripts Installer ==="
echo "This script will help you install various components from the butterscripts repository."
echo "-------------------------------"

# Geany
if ask_yes_no "Do you want to install Geany with plugins and colorschemes?"; then
    echo "Installing Geany with plugins and colorschemes..."
    run_butterscript "config/install_geany.sh"
    echo "Geany installation completed."
fi

# Discord
if ask_yes_no "Do you want to install Discord?"; then
    echo "Installing Discord..."
    run_butterscript "discord/discord"
    echo "Discord installation completed."
fi

# Browsers
if ask_yes_no "Do you want to install browsers?"; then
    echo "Installing browsers..."
    run_butterscript "browsers/install_browsers.sh"
    echo "Browsers installation completed."
fi

# Printer support
if ask_yes_no "Do you want to install printer support?"; then
    echo "Installing printer support..."
    run_butterscript "system/install_printer_support.sh"
    echo "Printer support installation completed."
fi

# Bluetooth
if ask_yes_no "Do you want to install Bluetooth support?"; then
    echo "Installing Bluetooth support..."
    run_butterscript "system/install_bluetooth.sh"
    echo "Bluetooth installation completed."
fi

# Fastfetch
echo ""
echo "The following script will install Fastfetch and configure it with multiple presets:"
echo "- Default: A standard configuration"
echo "- Minimal: A simplified view"
echo "- Server: A configuration optimized for server environments"
echo ""
if ask_yes_no "Do you want to install Fastfetch with configuration?"; then
    echo "Installing and configuring Fastfetch..."
    run_butterscript "fastfetch/install_fastfetch.sh"
    echo "Fastfetch installation completed."
fi

# Neovim
echo "Neovim Installation Options:"
echo "1. Build and install Neovim from source (no configuration)"
echo "2. Install Butterscripts Neovim configuration (assumes Neovim is already installed)"
echo "3. Skip Neovim installation"
read -p "Choose an option (1-3): " neovim_option

case $neovim_option in
    1)
        echo "Building and installing Neovim from source..."
        run_butterscript "neovim/build-neovim.sh"
        echo "Neovim build and installation completed."
        ;;
    2)
        echo "Installing Butterscripts Neovim configuration..."
        run_butterscript "neovim/buttervim.sh"
        echo "Butterscripts Neovim configuration installation completed."
        ;;
    3)
        echo "Skipping Neovim installation."
        ;;
    *)
        echo "Invalid option. Skipping Neovim installation."
        ;;
esac

echo "-------------------------------"
echo "Installation process completed."
echo "Thank you for using Butterscripts!"