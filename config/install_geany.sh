#!/bin/bash

# Install Geany and plugins
sudo apt install -y geany geany-plugin-addons geany-plugin-git-changebar geany-plugin-spellcheck geany-plugin-treebrowser geany-plugin-markdown geany-plugin-insertnum geany-plugin-lineoperations geany-plugin-automark 

# Clone and install Geany themes from drewgrif repository
echo "Installing Geany color schemes..."
mkdir -p ~/.config/geany/colorschemes
git clone https://github.com/drewgrif/geany-themes.git /tmp/geany-themes
cp -r /tmp/geany-themes/colorschemes/* ~/.config/geany/colorschemes/
rm -rf /tmp/geany-themes
echo "Geany themes installed successfully!"
