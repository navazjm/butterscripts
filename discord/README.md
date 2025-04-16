# 🧈 Butter Discord

A simple Discord installer and updater for Linux systems.

> **Note:** The setup process will ask for permission before modifying your shell configuration files. You can decline and manually add ~/.local/bin to your PATH if preferred.

## Features
- Installs and updates Discord with a single command
- Works with Bash, Zsh, Fish, and other shells
- User-level installation to ~/.local/bin
- Automatic shell environment configuration
- Clean uninstallation option

## Requirements
- Linux-based operating system
- wget for downloading files
- sudo privileges for Discord installation

## Installation
To set up Butter Discord:
```bash
# Clone repository
git clone https://github.com/drewgrif/butterscripts.git

# Navigate to discord directory
cd butterscripts/discord

# Make executable
chmod +x butter-discord.sh

# Setup script in your environment
./butter-discord.sh setup

```

## Usage
```bash
# Install or update Discord
butter-discord

# Uninstall Discord
butter-discord uninstall

# Show help information
butter-discord help
```

## How It Works
The script:
1. Downloads the latest Discord Linux package
2. Extracts it to /opt/Discord
3. Creates necessary symbolic links and desktop entries
4. Handles cleanup during updates/uninstallation

## Project Info
Made for Linux Discord users who want simple installation and updates.

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
```
