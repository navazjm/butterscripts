#!/bin/bash
set -e
# starship.sh: Install Starship Prompt and configure for Bash

if command -v starship &>/dev/null; then
    echo "Starship is already installed. Skipping."
else
    echo "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# Append to .bashrc if not already present
BASHRC="$HOME/.bashrc"
INIT_LINE='eval "$(starship init bash)"'

if ! grep -Fxq "$INIT_LINE" "$BASHRC"; then
    echo "$INIT_LINE" >> "$BASHRC"
    echo "Added Starship init line to .bashrc"
else
    echo "Starship already sourced in .bashrc"
fi
