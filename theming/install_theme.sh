#!/usr/bin/env bash

# ============================================
# Install GTK Theme & Icons
# ============================================

# Set color variables for better readability
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Set fixed configuration
INSTALL_DIR="$HOME/.local/src"
GTK_THEME="https://github.com/vinceliuice/Orchis-theme"
ICON_THEME="https://github.com/vinceliuice/Colloid-icon-theme"
GTK_THEME_NAME="Orchis-Grey-Dark"
ICON_THEME_NAME="Colloid-Grey-Dracula-Dark"

# Function to display error and exit
die() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    exit 1
}

# Function to check dependencies
check_dependencies() {
    echo -e "${BLUE}Checking dependencies...${NC}"
    
    # Check for git
    if ! command -v git &> /dev/null; then
        echo -e "${YELLOW}Git is not installed. Attempting to install...${NC}"
        sudo apt install -y git || die "Failed to install git. Please install it manually."
    fi
    
    echo -e "${GREEN}Dependencies satisfied.${NC}"
}

# Function to install themes
install_theming() {
    if [ -d "$HOME/.themes/$GTK_THEME_NAME" ] && [ -d "$HOME/.icons/$ICON_THEME_NAME" ]; then
        echo -e "${YELLOW}Themes already installed. Skipping theming installation.${NC}"
        return
    fi

    echo -e "${BLUE}Installing GTK and Icon themes...${NC}"
    mkdir -p "$INSTALL_DIR"

    # GTK Theme Installation
    echo -e "${BLUE}Cloning Orchis theme...${NC}"
    git clone "$GTK_THEME" "$INSTALL_DIR/Orchis-theme" || die "Failed to clone Orchis theme."
    cd "$INSTALL_DIR/Orchis-theme" || die "Failed to enter Orchis theme directory."
    
    echo -e "${BLUE}Installing Orchis theme with grey, teal, and orange variants${NC}"
    yes | ./install.sh -c dark -t default grey teal orange --tweaks black || {
        echo -e "${RED}Orchis theme installation failed.${NC}"
        exit 1
    }

    # Icon Theme Installation
    echo -e "${BLUE}Cloning Colloid icon theme...${NC}"
    git clone "$ICON_THEME" "$INSTALL_DIR/Colloid-icon-theme" || die "Failed to clone Colloid icon theme."
    cd "$INSTALL_DIR/Colloid-icon-theme" || die "Failed to enter Colloid icon theme directory."
    
    echo -e "${BLUE}Installing Colloid icon theme...${NC}"
    ./install.sh -t teal orange grey default -s default gruvbox everforest dracula || {
        echo -e "${RED}Colloid icon theme installation failed.${NC}"
        exit 1
    }

    echo -e "${GREEN}Theming installation complete.${NC}"
}

# Function to apply theme settings
change_theming() {
    echo -e "${BLUE}Applying GTK theme settings...${NC}"

    mkdir -p ~/.config/gtk-3.0

    cat << EOF > ~/.config/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=$GTK_THEME_NAME
gtk-icon-theme-name=$ICON_THEME_NAME
gtk-font-name=Sans 10
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
EOF

    cat << EOF > ~/.gtkrc-2.0
gtk-theme-name="$GTK_THEME_NAME"
gtk-icon-theme-name="$ICON_THEME_NAME"
gtk-font-name="Sans 10"
gtk-cursor-theme-name="Adwaita"
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle="hintfull"
EOF

    echo -e "${GREEN}GTK settings updated.${NC}"
}

# Handle script interruption
cleanup_incomplete() {
    echo -e "\n${YELLOW}Script interrupted. Cleaning up...${NC}"
    exit 1
}

# Set the trap for SIGINT (Ctrl+C)
trap cleanup_incomplete SIGINT

# Main execution
echo -e "${BLUE}=== GTK Theme & Icons Installer ===${NC}"

# Check dependencies first
check_dependencies

# Run installation steps
install_theming
change_theming

echo -e "${GREEN}Installation and configuration completed successfully!${NC}"
echo -e "${YELLOW}You may need to log out and log back in for changes to take effect.${NC}"
