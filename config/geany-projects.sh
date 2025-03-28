#!/bin/bash

PROJECT_DIR="$HOME/projects"

# Get full list of .geany project files
PROJECTS=$(find "$PROJECT_DIR" -maxdepth 1 -type f -name "*.geany")

# Exit if no projects found
[ -z "$PROJECTS" ] && notify-send "No Geany projects found in $PROJECT_DIR" && exit 1

# Use basename (filename only) for the rofi list
CHOICE=$(echo "$PROJECTS" | xargs -n 1 basename | rofi -dmenu -i -p "Open Geany Project:" -theme "$HOME/.config/suckless/rofi/keybinds.rasi")

# If a project was selected
if [ -n "$CHOICE" ]; then
    # Reconstruct full path and open in Geany
    geany -p "$PROJECT_DIR/$CHOICE"
fi
