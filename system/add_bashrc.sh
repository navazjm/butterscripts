#!/bin/bash

read -p "Replace your .bashrc with justaguylinux .bashrc? (y/n) " response
if [[ "$response" =~ ^[Yy]$ ]]; then
    [[ -f ~/.bashrc ]] && mv ~/.bashrc ~/.bashrc.bak
    wget -O ~/.bashrc https://raw.githubusercontent.com/drewgrif/jag_dots/main/.bashrc && source ~/.bashrc
fi
