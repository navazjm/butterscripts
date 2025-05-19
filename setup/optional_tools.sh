#!/bin/bash

# Butter Applications Installer
# This script allows you to choose which applications to install from the
# butterscripts repository by drewgrif, and also provides APT-based installations.

# Define color codes
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to display script header
show_header() {
    clear
    echo -e "${CYAN}=========================================================${NC}"
    echo -e "${CYAN}           BUTTER APPLICATIONS INSTALLER                 ${NC}"
    echo -e "${CYAN}=========================================================${NC}"
    echo -e "${YELLOW}This script will help you install various applications${NC}"
    echo -e "${YELLOW}from the butterscripts repository and APT packages.${NC}"
    echo
}

# Function to ask yes/no questions
ask_yes_no() {
    local prompt="$1"
    local response
    
    while true; do
        read -p "$prompt [y/n]: " response
        case "${response,,}" in
            y|yes) return 0 ;;
            n|no) return 1 ;;
            *) echo -e "${RED}Please answer yes or no.${NC}" ;;
        esac
    done
}

# Function to download a script from GitHub
download_script() {
    local script_url="$1"
    local script_name="$2"
    
    echo -e "${YELLOW}Downloading $script_name...${NC}"
    wget -q "$script_url" -O "/tmp/$script_name"
    chmod +x "/tmp/$script_name"
    echo -e "${GREEN}Download complete.${NC}"
}

# Function to install Geany
install_geany() {
    show_header
    echo -e "${CYAN}Installing Geany and plugins...${NC}"
    
    # Download the script
    download_script "https://raw.githubusercontent.com/drewgrif/butterscripts/refs/heads/main/config/install_geany.sh" "install_geany.sh"
    
    # Execute the script
    bash "/tmp/install_geany.sh"
    
    echo -e "${GREEN}Geany installation completed.${NC}"
    read -p "Press Enter to continue..."
}

# Function to install Browsers
install_browsers() {
    show_header
    echo -e "${CYAN}Installing Browsers...${NC}"
    echo -e "${YELLOW}Note: The browser installer will present its own menu${NC}"
    echo -e "${YELLOW}      for you to select which browser(s) to install.${NC}"
    echo
    
    # Download the script
    download_script "https://raw.githubusercontent.com/drewgrif/butterscripts/refs/heads/main/browsers/install_browsers.sh" "install_browsers.sh"
    
    echo -e "${YELLOW}Starting browser installer...${NC}"
    echo -e "${YELLOW}Follow the prompts to select which browsers to install.${NC}"
    echo
    
    # Execute the script
    bash "/tmp/install_browsers.sh"
    
    echo -e "${GREEN}Browsers installation process completed.${NC}"
    read -p "Press Enter to continue..."
}

# Function to install Discord
install_discord() {
    show_header
    echo -e "${CYAN}Installing Discord...${NC}"
    echo -e "${YELLOW}Note: The Discord installer has various options${NC}"
    echo -e "${YELLOW}      (install, uninstall, setup, etc.)${NC}"
    echo
    
    # Download the script
    download_script "https://raw.githubusercontent.com/drewgrif/butterscripts/refs/heads/main/discord/discord" "discord"
    
    echo -e "${YELLOW}Starting Discord installer...${NC}"
    echo -e "${YELLOW}Follow the prompts during installation.${NC}"
    echo
    
    # Execute the script with install option
    bash "/tmp/discord" install
    
    echo -e "${GREEN}Discord installation process completed.${NC}"
    read -p "Press Enter to continue..."
}

# Function to install Fastfetch
install_fastfetch() {
    show_header
    echo -e "${CYAN}Installing Fastfetch...${NC}"
    
    # Create a temporary directory for fastfetch configs
    mkdir -p /tmp/fastfetch-configs
    
    # Download the script
    download_script "https://raw.githubusercontent.com/drewgrif/butterscripts/refs/heads/main/fastfetch/install_fastfetch.sh" "install_fastfetch.sh"
    
    # Download config files needed by the script
    wget -q "https://raw.githubusercontent.com/drewgrif/butterscripts/refs/heads/main/fastfetch/config.jsonc" -O "/tmp/fastfetch-configs/config.jsonc"
    wget -q "https://raw.githubusercontent.com/drewgrif/butterscripts/refs/heads/main/fastfetch/minimal.jsonc" -O "/tmp/fastfetch-configs/minimal.jsonc"
    wget -q "https://raw.githubusercontent.com/drewgrif/butterscripts/refs/heads/main/fastfetch/server.jsonc" -O "/tmp/fastfetch-configs/server.jsonc"
    
    # Set script directory to the temporary location
    export script_dir="/tmp/fastfetch-configs"
    
    # Execute the script
    bash "/tmp/install_fastfetch.sh"
    
    echo -e "${GREEN}Fastfetch installation completed.${NC}"
    read -p "Press Enter to continue..."
}

# Function to install Neovim using butterscripts
install_butter_neovim() {
    show_header
    echo -e "${CYAN}Installing Neovim using buttervim.sh...${NC}"
    echo -e "${YELLOW}Note: This will install JustAGuyLinux's Neovim configuration.${NC}"
    echo -e "${YELLOW}      Any existing Neovim configuration will be backed up.${NC}"
    echo
    
    # Download the script
    download_script "https://raw.githubusercontent.com/drewgrif/butterscripts/refs/heads/main/neovim/buttervim.sh" "buttervim.sh"
    
    echo -e "${YELLOW}Starting Neovim installation...${NC}"
    echo -e "${YELLOW}Follow the prompts during installation.${NC}"
    echo
    
    # Execute the script
    bash "/tmp/buttervim.sh"
    
    echo -e "${GREEN}Neovim installation process completed.${NC}"
    read -p "Press Enter to continue..."
}

# Function to build and install Neovim from source
build_neovim() {
    show_header
    echo -e "${CYAN}Building and installing Neovim from source...${NC}"
    
    # Download the script
    download_script "https://raw.githubusercontent.com/drewgrif/butterscripts/refs/heads/main/neovim/build-neovim.sh" "build-neovim.sh"
    
    # Execute the script
    bash "/tmp/build-neovim.sh"
    
    echo -e "${GREEN}Neovim build and installation completed.${NC}"
    read -p "Press Enter to continue..."
}

# Function to install Printer Support
install_printer_support() {
    show_header
    echo -e "${CYAN}Installing Printer Support...${NC}"
    
    # Define printer-related packages
    local printer_packages=(
        "cups" 
        "cups-client" 
        "cups-filters" 
        "cups-pdf" 
        "printer-driver-all" 
        "printer-driver-cups-pdf" 
        "system-config-printer" 
        "hplip" 
        "sane-utils" 
        "xsane" 
        "simple-scan"
    )
    
    # Display the packages to be installed
    echo -e "${YELLOW}The following printer-related packages will be installed:${NC}"
    echo
    
    for pkg in "${printer_packages[@]}"; do
        echo -e "- $pkg"
    done
    
    echo
    if ! ask_yes_no "Do you want to install these printer support packages?"; then
        echo -e "${YELLOW}Installation cancelled.${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    # Install packages
    echo -e "${YELLOW}Updating package lists...${NC}"
    sudo apt update
    
    echo -e "${YELLOW}Installing printer support packages...${NC}"
    sudo apt install -y "${printer_packages[@]}"
    
    # Enable and start the CUPS service
    echo -e "${YELLOW}Enabling and starting CUPS service...${NC}"
    sudo systemctl enable cups
    sudo systemctl start cups
    
    echo -e "${GREEN}Printer support installation completed.${NC}"
    echo -e "${YELLOW}You can access the CUPS web interface at http://localhost:631${NC}"
    echo -e "${YELLOW}or use system-config-printer to configure your printers.${NC}"
    echo -e "${YELLOW}NOTE: A system reboot is recommended to ensure all services start properly.${NC}"
    read -p "Press Enter to continue..."
}

# Function to install Bluetooth Support
install_bluetooth_support() {
    show_header
    echo -e "${CYAN}Installing Bluetooth Support...${NC}"
    
    # Define bluetooth-related packages
    local bluetooth_packages=(
        "bluetooth" 
        "bluez" 
        "bluez-tools" 
        "bluez-cups" 
        "blueman" 
        "pulseaudio-module-bluetooth"
    )
    
    # Display the packages to be installed
    echo -e "${YELLOW}The following bluetooth-related packages will be installed:${NC}"
    echo
    
    for pkg in "${bluetooth_packages[@]}"; do
        echo -e "- $pkg"
    done
    
    echo
    if ! ask_yes_no "Do you want to install these bluetooth support packages?"; then
        echo -e "${YELLOW}Installation cancelled.${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    # Install packages
    echo -e "${YELLOW}Updating package lists...${NC}"
    sudo apt update
    
    echo -e "${YELLOW}Installing bluetooth support packages...${NC}"
    sudo apt install -y "${bluetooth_packages[@]}"
    
    # Enable and start the Bluetooth service
    echo -e "${YELLOW}Enabling and starting Bluetooth service...${NC}"
    sudo systemctl enable bluetooth
    sudo systemctl start bluetooth
    
    echo -e "${GREEN}Bluetooth support installation completed.${NC}"
    echo -e "${YELLOW}You can use the Bluetooth Manager (blueman) to connect devices.${NC}"
    echo -e "${YELLOW}NOTE: A system reboot is recommended to ensure all services start properly.${NC}"
    read -p "Press Enter to continue..."
}

# Function to prompt for package selection from a category
prompt_category() {
    local -n category_array=$1
    local category_name=$2
    local -n selected_array=$3
    local choice
    
    show_header
    echo -e "${CYAN}Select ${category_name}:${NC}"
    echo -e "${YELLOW}Enter the numbers of the packages you want to install (space-separated)${NC}"
    echo -e "${YELLOW}or '0' to skip this category.${NC}"
    echo
    
    # Display the options
    for i in "${!category_array[@]}"; do
        echo -e "${CYAN}$((i+1)). ${NC}${category_array[$i]}"
    done
    
    echo -e "${CYAN}0. ${NC}Skip this category"
    echo
    
    read -p "Enter your choices (space-separated): " choice
    
    # Process the selection
    if [[ "$choice" != "0" ]]; then
        for num in $choice; do
            if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -gt 0 ] && [ "$num" -le "${#category_array[@]}" ]; then
                selected_array+=("${category_array[$((num-1))]}")
            fi
        done
    fi
}

# Function to handle APT-based installations
install_apt_packages() {
    # Define package categories
    local file_managers=("thunar" "pcmanfm" "krusader" "nautilus" "nemo" "dolphin" "ranger" "nnn" "lf")
    local graphics=("gimp" "flameshot" "eog" "sxiv" "qimgv" "inkscape" "maim")
    local terminals=("alacritty" "gnome-terminal" "kitty" "konsole" "terminator" "xfce4-terminal")
    local text_editors=("kate" "gedit" "l3afpad" "mousepad" "pluma")
    local multimedia=("mpv" "vlc" "audacity" "kdenlive" "obs-studio" "rhythmbox" "ncmpcpp" "mkvtoolnix-gui")
    local utilities=("gparted" "gnome-disk-utility" "nitrogen" "numlockx" "galculator" "cpu-x" "dnsutils" "whois" "curl" "tree" "btop" "htop" "bat" "brightnessctl")
    local printer=("cups" "cups-client" "cups-filters" "printer-driver-all" "system-config-printer" "hplip" "simple-scan")
    local bluetooth=("bluetooth" "bluez" "bluez-tools" "blueman" "pulseaudio-module-bluetooth")
    
    # Arrays to store selected packages
    declare -a selected_file_managers=()
    declare -a selected_graphics=()
    declare -a selected_terminals=()
    declare -a selected_text_editors=()
    declare -a selected_multimedia=()
    declare -a selected_utilities=()
    declare -a selected_printer=()
    declare -a selected_bluetooth=()
    declare -a all_selections=()
    declare -a custom_packages=()
    
    # Prompt each category
    prompt_category file_managers "File Managers" selected_file_managers
    prompt_category graphics "Graphics Applications" selected_graphics
    prompt_category terminals "Terminal Emulators" selected_terminals
    prompt_category text_editors "Text Editors" selected_text_editors
    prompt_category multimedia "Multimedia Applications" selected_multimedia
    prompt_category utilities "Utilities" selected_utilities
    prompt_category printer "Printer Support" selected_printer
    prompt_category bluetooth "Bluetooth Support" selected_bluetooth
    
    # Add custom packages
    show_header
    echo -e "${CYAN}Custom Packages:${NC}"
    echo -e "${YELLOW}Enter any additional packages you want to install (space-separated)${NC}"
    echo -e "${YELLOW}or press Enter to skip.${NC}"
    echo
    
    read -p "Additional packages: " custom_input
    if [[ -n "$custom_input" ]]; then
        readarray -t custom_packages < <(echo "$custom_input" | tr ' ' '\n' | grep -v '^

# ButterScripts menu function
show_butterscripts_menu() {
    local choice
    
    while true; do
        show_header
        echo -e "${YELLOW}Select a ButterScript to install:${NC}"
        echo -e "${CYAN}1. ${NC}Geany - Text Editor with plugins"
        echo -e "${CYAN}2. ${NC}Browsers - Firefox, LibreWolf, Brave, Floorp, Vivaldi, Thorium, Zen"
        echo -e "${CYAN}3. ${NC}Discord - Chat and Voice Application"
        echo -e "${CYAN}4. ${NC}Fastfetch - System Information Display Tool"
        echo -e "${CYAN}5. ${NC}Neovim using ButterVim Script - Text Editor"
        echo -e "${CYAN}6. ${NC}Build Neovim from Source - Advanced"
        echo -e "${CYAN}7. ${NC}Return to Main Menu"
        echo
        echo -e "${YELLOW}NOTE: Each installer has its own interactive options.${NC}"
        echo -e "${YELLOW}      It's recommended to install one at a time.${NC}"
        echo
        read -p "Enter your choice [1-7]: " choice
        
        case $choice in
            1) install_geany ;;
            2) install_browsers ;;
            3) install_discord ;;
            4) install_fastfetch ;;
            5) install_butter_neovim ;;
            6) build_neovim ;;
            7) return ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                read -p "Press Enter to continue..."
                ;;
        esac
    done
}

# System Support menu function
show_system_support_menu() {
    local choice
    
    while true; do
        show_header
        echo -e "${YELLOW}System Support Installations:${NC}"
        echo -e "${CYAN}1. ${NC}Printer Support - CUPS and related drivers"
        echo -e "${CYAN}2. ${NC}Bluetooth Support - BluezZ and related utilities"
        echo -e "${CYAN}3. ${NC}Return to Main Menu"
        echo
        read -p "Enter your choice [1-3]: " choice
        
        case $choice in
            1) install_printer_support ;;
            2) install_bluetooth_support ;;
            3) return ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                read -p "Press Enter to continue..."
                ;;
        esac
    done
}

# Function to handle system reboot
reboot_system() {
    show_header
    echo -e "${CYAN}System Reboot${NC}"
    echo -e "${YELLOW}A reboot is recommended after installing system services${NC}"
    echo -e "${YELLOW}or drivers to ensure all changes take effect properly.${NC}"
    echo
    
    if ask_yes_no "Do you want to reboot the system now?"; then
        echo -e "${GREEN}Initiating system reboot...${NC}"
        sleep 2
        sudo reboot
    else
        echo -e "${YELLOW}Reboot cancelled. You can reboot manually later.${NC}"
        read -p "Press Enter to continue..."
    fi
}

# Main menu function
show_main_menu() {
    local choice
    
    while true; do
        show_header
        echo -e "${YELLOW}Please select an installation option:${NC}"
        echo -e "${CYAN}1. ${NC}Butterscripts Installers"
        echo -e "${CYAN}2. ${NC}APT Package Installation"
        echo -e "${CYAN}3. ${NC}System Support (Printer & Bluetooth)"
        echo -e "${CYAN}4. ${NC}Reboot System"
        echo -e "${CYAN}5. ${NC}Exit"
        echo
        read -p "Enter your choice [1-5]: " choice
        
        case $choice in
            1) show_butterscripts_menu ;;
            2) install_apt_packages ;;
            3) show_system_support_menu ;;
            4) reboot_system ;;
            5) 
                echo -e "${GREEN}Exiting installer. Thank you for using Butter Installer!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                read -p "Press Enter to continue..."
                ;;
        esac
    done
}

# Ensure we have wget installed
if ! command -v wget &>/dev/null; then
    echo -e "${YELLOW}Installing wget, which is required for downloading scripts...${NC}"
    sudo apt update
    sudo apt install -y wget
fi

# Start the main menu
show_main_menu
)
    fi
    
    # Compile all selected packages
    all_selections=("${selected_file_managers[@]}" "${selected_graphics[@]}" 
                   "${selected_terminals[@]}" "${selected_text_editors[@]}" 
                   "${selected_multimedia[@]}" "${selected_utilities[@]}"
                   "${selected_printer[@]}" "${selected_bluetooth[@]}"
                   "${custom_packages[@]}")
    
    # Remove any duplicates
    if [[ ${#all_selections[@]} -gt 0 ]]; then
        readarray -t all_selections < <(printf '%s\n' "${all_selections[@]}" | sort -u)
    fi
    
    # If no packages were selected, return
    if [[ ${#all_selections[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No packages selected.${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    # Display all selected packages
    show_header
    echo -e "${CYAN}Review Selected Packages:${NC}"
    echo -e "${YELLOW}You've selected the following packages to install:${NC}"
    echo
    
    for pkg in "${all_selections[@]}"; do
        echo -e "- $pkg"
    done
    
    echo
    if ! ask_yes_no "Do you want to install these packages?"; then
        echo -e "${YELLOW}Installation cancelled.${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    # Install packages
    show_header
    echo -e "${CYAN}Installing Selected Packages...${NC}"
    echo
    
    # Update package lists
    echo -e "${YELLOW}Updating package lists...${NC}"
    sudo apt update
    
    # Install selected packages
    echo -e "${YELLOW}Installing selected packages...${NC}"
    sudo apt install -y "${all_selections[@]}"
    
    # Keep track if system services were installed
    local system_services_installed=false
    
    # Enable services if needed
    if [[ " ${all_selections[*]} " =~ " cups " ]]; then
        echo -e "${YELLOW}Enabling and starting CUPS service...${NC}"
        sudo systemctl enable cups
        sudo systemctl start cups
        system_services_installed=true
    fi
    
    if [[ " ${all_selections[*]} " =~ " bluetooth " ]] || [[ " ${all_selections[*]} " =~ " bluez " ]]; then
        echo -e "${YELLOW}Enabling and starting Bluetooth service...${NC}"
        sudo systemctl enable bluetooth
        sudo systemctl start bluetooth
        system_services_installed=true
    fi
    
    echo -e "${GREEN}APT package installation completed.${NC}"
    
    # Suggest reboot if system services were installed
    if [[ "$system_services_installed" = true ]]; then
        echo -e "${YELLOW}NOTE: System services were installed. A reboot is recommended.${NC}"
        echo -e "${YELLOW}      You can use the 'Reboot System' option in the main menu.${NC}"
    fi
    
    read -p "Press Enter to continue..."
}

# ButterScripts menu function
show_butterscripts_menu() {
    local choice
    
    while true; do
        show_header
        echo -e "${YELLOW}Select a ButterScript to install:${NC}"
        echo -e "${CYAN}1. ${NC}Geany - Text Editor with plugins"
        echo -e "${CYAN}2. ${NC}Browsers - Firefox, LibreWolf, Brave, Floorp, Vivaldi, Thorium, Zen"
        echo -e "${CYAN}3. ${NC}Discord - Chat and Voice Application"
        echo -e "${CYAN}4. ${NC}Fastfetch - System Information Display Tool"
        echo -e "${CYAN}5. ${NC}Neovim using ButterVim Script - Text Editor"
        echo -e "${CYAN}6. ${NC}Build Neovim from Source - Advanced"
        echo -e "${CYAN}7. ${NC}Return to Main Menu"
        echo
        echo -e "${YELLOW}NOTE: Each installer has its own interactive options.${NC}"
        echo -e "${YELLOW}      It's recommended to install one at a time.${NC}"
        echo
        read -p "Enter your choice [1-7]: " choice
        
        case $choice in
            1) install_geany ;;
            2) install_browsers ;;
            3) install_discord ;;
            4) install_fastfetch ;;
            5) install_butter_neovim ;;
            6) build_neovim ;;
            7) return ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                read -p "Press Enter to continue..."
                ;;
        esac
    done
}

# System Support menu function
show_system_support_menu() {
    local choice
    
    while true; do
        show_header
        echo -e "${YELLOW}System Support Installations:${NC}"
        echo -e "${CYAN}1. ${NC}Printer Support - CUPS and related drivers"
        echo -e "${CYAN}2. ${NC}Bluetooth Support - BluezZ and related utilities"
        echo -e "${CYAN}3. ${NC}Return to Main Menu"
        echo
        read -p "Enter your choice [1-3]: " choice
        
        case $choice in
            1) install_printer_support ;;
            2) install_bluetooth_support ;;
            3) return ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                read -p "Press Enter to continue..."
                ;;
        esac
    done
}

# Function to handle system reboot
reboot_system() {
    show_header
    echo -e "${CYAN}System Reboot${NC}"
    echo -e "${YELLOW}A reboot is recommended after installing system services${NC}"
    echo -e "${YELLOW}or drivers to ensure all changes take effect properly.${NC}"
    echo
    
    if ask_yes_no "Do you want to reboot the system now?"; then
        echo -e "${GREEN}Initiating system reboot...${NC}"
        sleep 2
        sudo reboot
    else
        echo -e "${YELLOW}Reboot cancelled. You can reboot manually later.${NC}"
        read -p "Press Enter to continue..."
    fi
}

# Main menu function
show_main_menu() {
    local choice
    
    while true; do
        show_header
        echo -e "${YELLOW}Please select an installation option:${NC}"
        echo -e "${CYAN}1. ${NC}Butterscripts Installers"
        echo -e "${CYAN}2. ${NC}APT Package Installation"
        echo -e "${CYAN}3. ${NC}System Support (Printer & Bluetooth)"
        echo -e "${CYAN}4. ${NC}Reboot System"
        echo -e "${CYAN}5. ${NC}Exit"
        echo
        read -p "Enter your choice [1-5]: " choice
        
        case $choice in
            1) show_butterscripts_menu ;;
            2) install_apt_packages ;;
            3) show_system_support_menu ;;
            4) reboot_system ;;
            5) 
                echo -e "${GREEN}Exiting installer. Thank you for using Butter Installer!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                read -p "Press Enter to continue..."
                ;;
        esac
    done
}

# Ensure we have wget installed
if ! command -v wget &>/dev/null; then
    echo -e "${YELLOW}Installing wget, which is required for downloading scripts...${NC}"
    sudo apt update
    sudo apt install -y wget
fi

# Start the main menu
show_main_menu
