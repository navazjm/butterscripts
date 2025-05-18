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
if ask_yes_no "Do you want to install Geany?"; then
    echo "Installing Geany..."
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

echo "-------------------------------"
echo "Installation process completed."
echo "Thank you for using Butterscripts!"