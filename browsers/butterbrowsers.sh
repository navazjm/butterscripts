#!/bin/bash

# Browser Installation Scripts for Debian Stable
# This script provides installation methods for various browsers
# targeting the latest versions available for Debian Stable

# Check if running on Debian
if [ ! -f /etc/debian_version ]; then
    echo "This script is optimized for Debian. Your system may not be compatible."
    read -p "Continue anyway? (y/n): " continue_anyway
    if [[ "$continue_anyway" != "y" && "$continue_anyway" != "Y" ]]; then
        exit 1
    fi
fi

# Make sure we have basic dependencies
ensure_dependencies() {
    echo "Installing essential dependencies..."
    sudo apt update
    sudo apt install -y wget curl apt-transport-https gnupg ca-certificates software-properties-common
}

# Choose browsers to install
show_menu() {
    while true; do
        clear
        echo "==========================================="
        echo "  BROWSER INSTALLATION SCRIPTS (DEBIAN)   "
        echo "==========================================="
        echo "Enter numbers of browsers to install (separated by spaces):"
        echo "1. Firefox Latest"
        echo "2. LibreWolf"
        echo "3. Brave"
        echo "4. Floorp"
        echo "5. Vivaldi"
        echo "6. Thorium"
        echo "7. Zen Browser"
        echo "8. All Browsers"
        echo "9. Exit"
        echo "-------------------------------------------"
        
        # Simple read command with normal terminal behavior
        read -p "Enter your choice(s): " input
        
        # Check if input is empty
        if [ -z "$input" ]; then
            continue
        fi
        
        # Check if user wants to exit with option 9
        if [[ "$input" == "9" ]]; then
            echo "Exiting..."
            exit 0
        fi
        
        # Install all browsers if option 8 is selected
        if [[ "$input" == "8" ]]; then
            install_firefox
            install_librewolf
            install_brave
            install_floorp
            install_vivaldi
            install_thorium
            install_zen
            echo "All browsers have been installed!"
            read -p "Press Enter to continue or Ctrl+C to exit..."
            continue
        fi
        
        # Process each selection
        for choice in $input; do
            case $choice in
                1) install_firefox ;;
                2) install_librewolf ;;
                3) install_brave ;;
                4) install_floorp ;;
                5) install_vivaldi ;;
                6) install_thorium ;;
                7) install_zen ;;
                *) echo "Invalid choice: $choice (skipping)" ;;
            esac
        done
        
        echo "Selected browsers have been installed!"
        read -p "Press Enter to continue or Ctrl+C to exit..."
    done
}

# Function to install Firefox
install_firefox() {
    echo "Installing Firefox Latest..."
    
    # Define variables
    FIREFOX_DIR="/opt/firefox"
    FIREFOX_BIN="/usr/local/bin/firefox"
    DESKTOP_FILE="/usr/local/share/applications/firefox.desktop"
    TAR_FILE="firefox.tar.xz"
    TEMP_DIR="/opt/firefox-latest"

    # Function to clean up old Firefox installation
    cleanup() {
        echo "Cleaning up old Firefox installation..."
        sudo rm -rf "$FIREFOX_DIR"
        sudo rm -f "$FIREFOX_BIN"
        sudo rm -f "$DESKTOP_FILE"
    }

    # Check if Firefox is installed and clean up if necessary
    if [ -d "$FIREFOX_DIR" ] || [ -f "$FIREFOX_BIN" ]; then
        cleanup
    fi

    # Install or update Firefox
    echo "Retrieving the latest Firefox tar.xz file..."
    wget "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US" -O "$TAR_FILE"

    echo "Extracting files to a temporary directory..."
    sudo mkdir -p "$TEMP_DIR"
    sudo tar -xvf "$TAR_FILE" -C "$TEMP_DIR" --strip-components=1
    rm "$TAR_FILE"

    echo "Moving extracted files to /opt/firefox..."
    sudo rm -rf "$FIREFOX_DIR"
    sudo mv "$TEMP_DIR" "$FIREFOX_DIR"

    echo "Creating symbolic link in /usr/local/bin..."
    sudo ln -sf "$FIREFOX_DIR/firefox" "$FIREFOX_BIN"

    echo "Downloading official Firefox desktop entry..."
    sudo wget "https://raw.githubusercontent.com/mozilla/sumo-kb/main/install-firefox-linux/firefox.desktop" -P /usr/local/share/applications

    echo "Firefox installation completed."
    echo "You can run Firefox by typing 'firefox' in the terminal or launching it from the applications menu."
}

# Function to install LibreWolf
install_librewolf() {
    echo "Installing LibreWolf..."
    
    # Install dependencies
    ensure_dependencies
    
    # First, remove any old LibreWolf repository files if they exist
    sudo rm -f \
        /etc/apt/sources.list.d/librewolf.sources \
        /etc/apt/keyrings/librewolf.gpg \
        /etc/apt/preferences.d/librewolf.pref \
        /etc/apt/sources.list.d/librewolf.list \
        /etc/apt/trusted.gpg.d/librewolf.gpg
    
    # Install extrepo tool
    sudo apt update
    sudo apt install -y extrepo
    
    # Enable LibreWolf repository via extrepo
    sudo extrepo enable librewolf
    
    # Update and install
    sudo apt update
    sudo apt install -y librewolf
    
    echo "LibreWolf installation complete!"
    echo "You can run LibreWolf by typing 'librewolf' in the terminal or launching it from the applications menu."
}

# Function to install Brave
install_brave() {
    echo "Installing Brave Browser..."
    
    # Install dependencies
    ensure_dependencies
    
    # Add Brave GPG key
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    
    # Add Brave repository
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    
    # Update and install
    sudo apt update
    sudo apt install -y brave-browser
    
    echo "Brave Browser installation complete!"
    echo "You can run Brave by typing 'brave-browser' in the terminal or launching it from the applications menu."
}

# Function to install Floorp
install_floorp() {
    echo "Installing Floorp Browser..."
    
    # Install dependencies
    ensure_dependencies
    
    # Add Floorp GPG key
    curl -fsSL https://ppa.ablaze.one/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/Floorp.gpg
    
    # Add Floorp repository
    sudo curl -sS --compressed -o /etc/apt/sources.list.d/Floorp.list 'https://ppa.ablaze.one/Floorp.list'
    
    # Update and install
    sudo apt update
    sudo apt install -y floorp
    
    echo "Floorp Browser installation complete!"
    echo "You can run Floorp by typing 'floorp' in the terminal or launching it from the applications menu."
}

# Function to install Vivaldi
install_vivaldi() {
    echo "Installing Vivaldi Browser..."
    
    # Install dependencies
    ensure_dependencies
    
    # Add Vivaldi key
    wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | sudo apt-key add -
    
    # Add Vivaldi repository
    echo "deb [arch=amd64] https://repo.vivaldi.com/archive/deb/ stable main" | sudo tee /etc/apt/sources.list.d/vivaldi.list
    
    # Update and install
    sudo apt update
    sudo apt install -y vivaldi-stable
    
    echo "Vivaldi Browser installation complete!"
    echo "You can run Vivaldi by typing 'vivaldi' or 'vivaldi-stable' in the terminal or launching it from the applications menu."
}

# Function to install Thorium
install_thorium() {
    echo "Installing Thorium Browser..."
    
    # Install dependencies
    ensure_dependencies
    
    # Clear existing repository if it exists
    sudo rm -fv /etc/apt/sources.list.d/thorium.list
    
    # Add Thorium repository
    sudo wget --no-hsts -P /etc/apt/sources.list.d/ \
    http://dl.thorium.rocks/debian/dists/stable/thorium.list
    
    # Update and install
    sudo apt update
    sudo apt install -y thorium-browser
    
    echo "Thorium Browser installation complete!"
    echo "You can run Thorium by typing 'thorium-browser' in the terminal or launching it from the applications menu."
}

# Function to install Zen Browser
install_zen() {
    echo "Installing Zen Browser..."
    
    # Define variables
    ZEN_DIR="/opt/zen"
    ZEN_BIN="/usr/local/bin/zen"
    DESKTOP_FILE="/usr/share/applications/zen-browser.desktop"
    TAR_FILE="zen.linux-x86_64.tar.xz"
    
    # Install dependencies
    ensure_dependencies
    
    # Download latest Zen Browser tarball
    echo "Downloading Zen Browser tarball..."
    wget "https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz" -O "$TAR_FILE"
    
    # Create installation directory
    echo "Creating installation directory..."
    sudo mkdir -p "$ZEN_DIR"
    
    # Extract Zen Browser
    echo "Extracting files to $ZEN_DIR..."
    sudo tar -xf "$TAR_FILE" -C "$ZEN_DIR" --strip-components=0
    rm "$TAR_FILE"
    
    # Create symbolic link in /usr/local/bin
    echo "Creating symbolic link in /usr/local/bin..."
    sudo ln -sf "$ZEN_DIR/zen" "$ZEN_BIN"
    
    # Create desktop entry
    echo "Creating desktop entry..."
    echo "[Desktop Entry]
Version=1.0
Name=Zen Browser
Comment=Experience tranquillity while browsing the web
GenericName=Web Browser
Keywords=Internet;WWW;Browser;Web;Explorer
Exec=zen %u
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=$ZEN_DIR/browser/chrome/icons/default/default128.png
Categories=GNOME;GTK;Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;video/webm;application/x-xpinstall;
StartupNotify=true" | sudo tee "$DESKTOP_FILE"
    
    echo "Zen Browser installation complete!"
    echo "You can run Zen Browser by typing 'zen' in the terminal or launching it from the applications menu."
}

# Ensure we have necessary privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script requires sudo privileges for installation."
    echo "You'll be prompted for your password when necessary."
fi

# Start installation process
ensure_dependencies
show_menu

exit 0
