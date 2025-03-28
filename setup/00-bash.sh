#!/bin/bash
set -e
# 00-base.sh: System update and base packages

sudo apt update
sudo apt upgrade -y
sudo apt install -y git curl build-essential xorg xorg-dev xbacklight xbindkeys xvkbd xinput xdg-user-dirs-gtk cmake meson ninja-build pkg-config
