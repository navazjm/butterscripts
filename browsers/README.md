# 🧈 Butter Browsers

A simple multi-browser installer for Debian-based Linux systems.

> **Note:** This script installs browsers from their official sources rather than potentially outdated Debian repositories.

## Features
- Installs multiple browsers with a single command
- Checks if browsers are already installed
- Adds necessary repositories and GPG keys automatically
- Uses AppImage for Zen Browser (no root required)
- Clean integration with your desktop environment

## Requirements
- Debian-based operating system
- wget and curl for downloading files
- sudo privileges for most installations

## Installation
To set up Butter Browsers:
```bash
# Download the script
wget -O install_browsers.sh https://raw.githubusercontent.com/yourusername/repository/main/install_browsers.sh

# Make executable
chmod +x install_browsers.sh

# Run the script
./install_browsers.sh
```

## Usage
```bash
# Run the script and select browsers
./install_browsers.sh

# Install specific browsers by number
# Example: Install Firefox (1) and Brave (3)
./install_browsers.sh
# Then enter: 1 3
```

## Supported Browsers
1. **Firefox** - Latest from Mozilla APT repository
2. **LibreWolf** - Privacy-focused Firefox fork
3. **Brave** - Privacy-focused Chromium browser
4. **Floorp** - Customizable Firefox-based browser
5. **Vivaldi** - Feature-rich Chromium browser
6. **Zen Browser** - Tranquil, distraction-free browsing (AppImage)
7. **Chromium** - Open-source base of Chrome
8. **Ungoogled Chromium** - Chromium without Google integration

## How It Works
The script:
1. Presents a menu of available browsers
2. Lets you select one or multiple browsers
3. Adds necessary repositories and keys
4. Installs each selected browser
5. Creates desktop entries for easy access

## Project Info
Made for Debian users who want the latest browser versions without the hassle.

---

## 🌐 Built For

- **Debian and derivatives** (Ubuntu, Mint, Pop!_OS, etc.)
- Users who prefer official browser sources
- Anyone who wants multiple browsers without manual setup

---

## Updating Browsers

- **Repository browsers** (Firefox, LibreWolf, Brave, Floorp, Vivaldi, Chromium, Ungoogled Chromium) will update through your system's package manager
- **Zen Browser** (AppImage) can be updated by running the script again

---

## 📫 Author

**JustAGuy Linux**  
🎥 [YouTube](https://youtube.com/@JustAGuyLinux)  

---

More scripts coming soon. Use what you need, fork what you like, tweak everything.
