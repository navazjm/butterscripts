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
    
    # Sanitize the path for the temp file - replace / with _
    local safe_name=$(echo "$script_path" | tr '/' '_')
    local temp_script="$MAIN_TEMP_DIR/scripts/$safe_name"
    
    # Create directory for downloaded scripts
    mkdir -p "$MAIN_TEMP_DIR/scripts"
    
    echo "Fetching script: $script_path from butterscripts repository..."
    
    # Explicitly check if the file already exists and remove it to avoid issues
    if [ -f "$temp_script" ]; then
        rm -f "$temp_script"
    fi
    
    # Download the script
    wget -q -O "$temp_script" "https://raw.githubusercontent.com/drewgrif/butterscripts/main/$script_path"
    local wget_status=$?
    
    # Remaining error checking and output as before...
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

# Function to prompt for multiple selections from a category
prompt_category() {
    local -n category=$1
    local category_name=$2
    local -n selected_items=$3
    
    echo ""
    echo "=== $category_name ==="
    
    # Display options
    for i in "${!category[@]}"; do
        echo "[$((i+1))] ${category[$i]}"
    done
    
    echo "[0] None / Skip"
    echo "[a] All"
    
    # Get user selection
    read -p "Enter your choices (space-separated numbers, 'a' for all, or '0' to skip): " choices
    
    # Process selection
    if [[ "$choices" == "a" || "$choices" == "A" ]]; then
        # Select all items
        selected_items=("${category[@]}")
    elif [[ "$choices" == "0" ]]; then
        # Skip this category
        selected_items=()
    else
        # Process individual selections
        selected_items=()
        for choice in $choices; do
            if [[ "$choice" =~ ^[0-9]+$ && "$choice" -ge 1 && "$choice" -le "${#category[@]}" ]]; then
                selected_items+=("${category[$((choice-1))]}")
            fi
        done
    fi
    
    # Show selected items
    if [ ${#selected_items[@]} -gt 0 ]; then
        echo "Selected: ${selected_items[*]}"
    else
        echo "No items selected."
    fi
}

# Function to install apt packages
install_packages() {
    local packages=("$@")
    
    if [ ${#packages[@]} -eq 0 ]; then
        return
    fi
    
    echo "Installing packages: ${packages[*]}"
    sudo apt update
    sudo apt install -y "${packages[@]}"
}

clear

# Welcome message
echo "=== Butterscripts Installer ==="
echo "This script will help you install various components from the butterscripts repository."
echo "-------------------------------"

# === Script-based installations ===
echo ""
echo "=== Script-based Installations ==="

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
echo ""
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

# === APT-based installations ===
echo ""
echo "=== APT-based Installations ==="

if ask_yes_no "Do you want to select and install APT packages?"; then
    # === APT-based categories ===
    file_managers=(thunar pcmanfm krusader nautilus nemo dolphin ranger nnn lf)
    graphics=(gimp flameshot eog sxiv qimgv inkscape maim)
    terminals=(alacritty gnome-terminal kitty konsole terminator xfce4-terminal)
    text_editors=(kate gedit l3afpad mousepad pluma)
    multimedia=(mpv vlc audacity kdenlive obs-studio rhythmbox ncmpcpp mkvtoolnix-gui)
    utilities=(gparted gnome-disk-utility nitrogen numlockx galculator cpu-x \
               dns-utils whois curl tree btop htop bat brightnessctl)

    # Arrays to store selected items
    declare -a selected_file_managers
    declare -a selected_graphics
    declare -a selected_terminals
    declare -a selected_text_editors
    declare -a selected_multimedia
    declare -a selected_utilities
    declare -a custom_packages

    # === Prompt APT categories ===
    prompt_category file_managers "File Managers" selected_file_managers
    prompt_category graphics "Graphics Applications" selected_graphics
    prompt_category terminals "Terminal Emulators" selected_terminals
    prompt_category text_editors "Text Editors" selected_text_editors
    prompt_category multimedia "Multimedia Applications" selected_multimedia
    prompt_category utilities "Utilities" selected_utilities
    
    # === Custom package input ===
    echo ""
    echo "=== Custom APT Packages ==="
    echo "Enter any additional APT packages you would like to install (space-separated)."
    echo "Example: git gcc make python3 neofetch"
    echo "Leave empty to skip."
    read -p "Custom packages: " custom_input
    
    # Process the custom input into an array
    if [ -n "$custom_input" ]; then
        # Split the input string into an array
        read -ra custom_packages <<< "$custom_input"
        echo "Custom packages selected: ${custom_packages[*]}"
    else
        echo "No custom packages selected."
    fi
    
    # Install selected packages
    all_selected_packages=(
        "${selected_file_managers[@]}"
        "${selected_graphics[@]}"
        "${selected_terminals[@]}"
        "${selected_text_editors[@]}"
        "${selected_multimedia[@]}"
        "${selected_utilities[@]}"
        "${custom_packages[@]}"
    )
    
    if [ ${#all_selected_packages[@]} -gt 0 ]; then
        echo ""
        echo "=== Installing Selected APT Packages ==="
        install_packages "${all_selected_packages[@]}"
        echo "APT package installation completed."
    else
        echo "No APT packages selected for installation."
    fi
fi

echo "-------------------------------"
echo "Installation process completed."
echo "Thank you for using Butterscripts!"
