#!/usr/bin/env bash

# ============================================
# Install GTK Theme & Icons
# ============================================

set -e

INSTALL_DIR="$HOME/.local/src"
GTK_THEME="https://github.com/vinceliuice/Orchis-theme"
ICON_THEME="https://github.com/vinceliuice/Colloid-icon-theme"

die() {
    echo "$1"
    exit 1
}

install_theming() {
    GTK_THEME_NAME="Orchis-Grey-Dark"
    ICON_THEME_NAME="Colloid-Grey-Dracula-Dark"

    if [ -d "$HOME/.themes/$GTK_THEME_NAME" ] || [ -d "$HOME/.icons/$ICON_THEME_NAME" ]; then
        echo "One or more themes/icons already installed. Skipping theming installation."
        return
    fi

    echo "Installing GTK and Icon themes..."
    mkdir -p "$INSTALL_DIR"

    # GTK Theme Installation
    git clone "$GTK_THEME" "$INSTALL_DIR/Orchis-theme" || die "Failed to clone Orchis theme."
    cd "$INSTALL_DIR/Orchis-theme" || die "Failed to enter Orchis theme directory."
    yes | ./install.sh -c dark -t default grey teal orange --tweaks black

    # Icon Theme Installation
    git clone "$ICON_THEME" "$INSTALL_DIR/Colloid-icon-theme" || die "Failed to clone Colloid icon theme."
    cd "$INSTALL_DIR/Colloid-icon-theme" || die "Failed to enter Colloid icon theme directory."
    ./install.sh -t teal orange grey default -s default gruvbox everforest dracula

    echo "Theming installation complete."
}

# ========================================
# GTK Theme Settings
# ========================================

change_theming() {
    echo "Applying GTK theme settings..."

    mkdir -p ~/.config/gtk-3.0

    cat << EOF > ~/.config/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=Orchis-Grey-Dark
gtk-icon-theme-name=Colloid-Grey-Dracula-Dark
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
gtk-theme-name="Orchis-Grey-Dark"
gtk-icon-theme-name="Colloid-Grey-Dracula-Dark"
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

    echo "GTK settings updated."
}

# Run both steps
install_theming
change_theming
