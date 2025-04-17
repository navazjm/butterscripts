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
wget -O butterbrowsers.sh https://raw.githubusercontent.com/yourusername/repository/main/butterbrowsers.sh

# Make executable
chmod +x butterbrowsers.sh

# Run the script
./butterbrowsers.sh
```

## Usage
```bash
# Run the script and select browsers
./butterbrowsers.sh

# Install specific browsers by number
# Example: Install Firefox (1) and Brave (3)
./butterbrowsers.sh
# Then enter: 1 3
```

## Supported Browsers
1. **Firefox** - Latest direct from Mozilla
2. **LibreWolf** - Privacy-focused Firefox fork
3. **Brave** - Privacy-focused Chromium browser
4. **Floorp** - Customizable Firefox-based browser
5. **Vivaldi** - Feature-rich Chromium browser
6. **Thorium** - Performance-optimized Chromium
7. **Zen Browser** - Tranquil, distraction-free browsing

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

- **Repository browsers** (LibreWolf, Brave, Floorp, Vivaldi, Thorium) will update through your system's package manager
- **Firefox and Zen Browser** can be updated by running the script again

---

## 📫 Author

**JustAGuy Linux**  
🎥 [YouTube](https://youtube.com/@JustAGuyLinux)  

---

More scripts coming soon. Use what you need, fork what you like, tweak everything.
