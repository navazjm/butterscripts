#!/bin/bash
set -e
# 01-apps.sh: Core applications and tools

sudo apt-get install -y \
    sxhkd thunar thunar-archive-plugin thunar-volman \
    nala lxappearance xfce4-power-manager \
    pavucontrol pulsemixer feh \
    fonts-recommended fonts-font-awesome fonts-terminus \
    exa flameshot qimgv rofi dunst libnotify-bin \
    xdotool libnotify-dev firefox-esr suckless-tools \
    redshift geany geany-plugin-addons geany-plugin-git-changebar \
    geany-plugin-spellcheck geany-plugin-treebrowser geany-plugin-markdown \
    geany-plugin-insertnum geany-plugin-lineoperations geany-plugin-automark \
    micro tilix lightdm || echo "Warning: Package installation failed."

echo "📦 App package installation completed."
