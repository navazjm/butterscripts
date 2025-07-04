#!/bin/bash

# ST Terminal Installer - Suckless version

set -e

# Install dependencies
sudo apt-get update || true
sudo apt-get install -y git make gcc libx11-dev libxft-dev libxinerama-dev

# Clone and build
git clone https://github.com/drewgrif/dwm-setup.git /tmp/st-build
cd /tmp/st-build/suckless/st
make
sudo make install

# Create desktop file
cat > ~/.local/share/applications/st.desktop << EOF
[Desktop Entry]
Name=st
Comment=Simple Terminal
Exec=st
Icon=utilities-terminal
Terminal=false
Type=Application
Categories=System;TerminalEmulator;
EOF

# Update desktop database
update-desktop-database ~/.local/share/applications/

# Cleanup
rm -rf /tmp/st-build

echo "ST installed. Available in rofi as 'st'."