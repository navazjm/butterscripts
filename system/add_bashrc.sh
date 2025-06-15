#!/bin/bash

if [ -t 0 ]; then
    read -p "Replace your .bashrc with justaguylinux .bashrc? (y/n) " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] || exit 0
fi

[ -f ~/.bashrc ] && mv ~/.bashrc ~/.bashrc.bak
wget -O ~/.bashrc https://raw.githubusercontent.com/drewgrif/jag_dots/main/.bashrc