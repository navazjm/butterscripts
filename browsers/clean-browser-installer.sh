#!/bin/bash

# Browser Installation Scripts for Debian Stable
# Maintained by JustAGuy Linux

# === Initial Checks ===
if [ ! -f /etc/debian_version ]; then
    echo "This script is optimized for Debian. Your system may not be compatible."
    read -p "Continue anyway? (y/n): " continue_anyway
    [[ "$continue_anyway" != "y" && "$continue_anyway" != "Y" ]] && exit 1
fi

# === Dependencies ===
ensure_dependencies() {
    echo "Installing essential dependencies..."
    sudo apt update
    sudo apt install -y wget curl apt-transport-https gnupg ca-certificates software-properties-common
}

# === Installers ===
install_firefox() {
    echo "Installing Firefox Latest..."
    FIREFOX_DIR="/opt/firefox"
    FIREFOX_BIN="/usr/local/bin/firefox"
    DESKTOP_FILE="/usr/local/share/applications/firefox.desktop"
    TEMP_DIR="/opt/firefox-latest"
    TAR_FILE="firefox.tar.xz"

    sudo rm -rf "$FIREFOX_DIR" "$FIREFOX_BIN" "$DESKTOP_FILE"

    wget "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US" -O "$TAR_FILE"
    sudo mkdir -p "$TEMP_DIR"
    sudo tar -xvf "$TAR_FILE" -C "$TEMP_DIR" --strip-components=1
    rm "$TAR_FILE"
    sudo mv "$TEMP_DIR" "$FIREFOX_DIR"
    sudo ln -sf "$FIREFOX_DIR/firefox" "$FIREFOX_BIN"
    sudo wget "https://raw.githubusercontent.com/mozilla/sumo-kb/main/install-firefox-linux/firefox.desktop" -P /usr/local/share/applications
    echo "Firefox installed."
}

install_librewolf() {
    echo "Installing LibreWolf..."
    ensure_dependencies
    wget -O- https://deb.librewolf.net/keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/librewolf.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/librewolf.gpg] https://deb.librewolf.net bookworm main" | sudo tee /etc/apt/sources.list.d/librewolf.list
    sudo apt update
    sudo apt install -y librewolf
    echo "LibreWolf installed."
}

install_brave() {
    echo "Installing Brave..."
    ensure_dependencies
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install -y brave-browser
    echo "Brave installed."
}

install_floorp() {
    echo "Installing Floorp..."
    ensure_dependencies
    curl -fsSL https://ppa.ablaze.one/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/Floorp.gpg
    sudo curl -sS --compressed -o /etc/apt/sources.list.d/Floorp.list 'https://ppa.ablaze.one/Floorp.list'
    sudo apt update
    sudo apt install -y floorp
    echo "Floorp installed."
}

install_vivaldi() {
    echo "Installing Vivaldi..."
    ensure_dependencies
    wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | gpg --dearmor | sudo tee /usr/share/keyrings/vivaldi.gpg > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/vivaldi.gpg] https://repo.vivaldi.com/archive/deb/ stable main" | sudo tee /etc/apt/sources.list.d/vivaldi.list
    sudo apt update
    sudo apt install -y vivaldi-stable
    echo "Vivaldi installed."
}

install_thorium() {
    echo "Installing Thorium..."
    ensure_dependencies
    sudo rm -f /etc/apt/sources.list.d/thorium.list
    sudo wget --no-hsts -P /etc/apt/sources.list.d/ http://dl.thorium.rocks/debian/dists/stable/thorium.list
    sudo apt update
    sudo apt install -y thorium-browser
    echo "Thorium installed."
}

install_zen() {
    echo "Installing Zen..."
    ensure_dependencies
    ZEN_DIR="/opt/zen"
    ZEN_BIN="/usr/local/bin/zen"
    DESKTOP_FILE="/usr/share/applications/zen-browser.desktop"
    TAR_FILE="zen.linux-x86_64.tar.xz"

    wget "https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz" -O "$TAR_FILE"
    sudo mkdir -p "$ZEN_DIR"
    sudo tar -xf "$TAR_FILE" -C "$ZEN_DIR" --strip-components=0
    rm "$TAR_FILE"
    sudo ln -sf "$ZEN_DIR/zen" "$ZEN_BIN"

    echo "[Desktop Entry]
Version=1.0
Name=Zen Browser
Comment=Experience tranquillity while browsing the web
Exec=zen %u
Terminal=false
Type=Application
Icon=$ZEN_DIR/browser/chrome/icons/default/default128.png
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;" | sudo tee "$DESKTOP_FILE"

    echo "Zen installed."
}

# === Menu ===
show_menu() {
    while true; do
        clear
        echo "Choose browsers to install (separate by space):"
        echo "1. Firefox  2. LibreWolf  3. Brave  4. Floorp"
        echo "5. Vivaldi  6. Thorium    7. Zen    8. All"
        echo "9. Exit"
        read -rp "> " input

        case "$input" in
            9) echo "Goodbye!"; exit 0 ;;
            8) for i in {1..7}; do $0 $i; done ;;
            *) for choice in $input; do
                case $choice in
                    1) install_firefox ;;
                    2) install_librewolf ;;
                    3) install_brave ;;
                    4) install_floorp ;;
                    5) install_vivaldi ;;
                    6) install_thorium ;;
                    7) install_zen ;;
                    *) echo "Invalid: $choice" ;;
                esac
            done ;;
        esac

        read -rp "Done. Press Enter to continue..."
    done
}

# === Main ===
ensure_dependencies
show_menu