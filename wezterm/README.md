# 🧈 Butter WezTerm
A simple WezTerm terminal emulator installer for Linux systems.
> **Note:** This script installs WezTerm terminal emulator on Debian-based systems.

## Features
- Installs WezTerm nightly build with a single command
- Custom configuration automatically applied
- Clean installation process

## Requirements
- Debian-based Linux distribution
- wget for downloading files
- sudo privileges for installation

## Installation
To install WezTerm:
```bash
# Clone repository
git clone https://github.com/drewgrif/butterscripts.git
# Navigate to wezterm directory
cd butterscripts/wezterm
# Make executable
chmod +x install_wezterm.sh
# Run the installer
./install_wezterm.sh
```

## How It Works
The script:
1. Adds the WezTerm repository and GPG key
2. Installs the latest WezTerm nightly build
3. Sets up configuration in ~/.config/wezterm
4. Uses the configuration from https://github.com/drewgrif/butterscripts/wezterm/wezterm.lua

## Project Info
Made for Linux users who want a powerful terminal emulator with simple installation.

---
## 🧈 Built For
- **Butter Bean (butterbian) Linux** (and other Debian-based systems)
- Window manager setups (BSPWM, Openbox, etc.)
- Users who like things lightweight, modular, and fast
> Butterbian Linux is a joke... for now.

---
## 📫 Author
**JustAGuy Linux**  
🎥 [YouTube](https://youtube.com/@JustAGuyLinux)  

---
More scripts coming soon. Use what you need, fork what you like, tweak everything.
