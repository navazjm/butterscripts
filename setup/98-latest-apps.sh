#!/bin/bash

# Install dialog if not present
command -v dialog >/dev/null || sudo apt install -y dialog

# Show checklist menu
choices=$(dialog --separate-output --checklist "Select tools to install:" 20 60 10 \
    1 "Fastfetch" on \
    2 "Discord" off \
    3 "Firefox (latest)" on \
    4 "Lazygit" off \
    5 "LibreWolf" off \
    6 "Neovim (latest)" on \
    7 "Starship" off \
    3>&1 1>&2 2>&3)

# Run selected
for choice in $choices; do
    case $choice in
        1) curl -fsSL "https://raw.githubusercontent.com/drewgrif/butterscripts/main/apps/fastfetch.sh" | bash ;;
        2) curl -fsSL "https://raw.githubusercontent.com/drewgrif/butterscripts/main/apps/discord.sh" | bash ;;
        3) curl -fsSL "https://raw.githubusercontent.com/drewgrif/butterscripts/main/apps/firefox-latest.sh" | bash ;;
        4) curl -fsSL "https://raw.githubusercontent.com/drewgrif/butterscripts/main/apps/lazygit.sh" | bash ;;
        5) curl -fsSL "https://raw.githubusercontent.com/drewgrif/butterscripts/main/apps/librewolf.sh" | bash ;;
        6) curl -fsSL "https://raw.githubusercontent.com/drewgrif/butterscripts/main/apps/neovim.sh" | bash ;;
        7) curl -fsSL "https://raw.githubusercontent.com/drewgrif/butterscripts/main/apps/starship.sh" | bash ;;
    esac
done
