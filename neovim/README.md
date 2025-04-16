# 🧈 Butter Neovim

A collection of simple Neovim installation scripts for Linux systems.

> **Note:** These scripts provide different installation methods for Neovim. Choose the one that best fits your needs.

## Included Scripts

This repository contains two Neovim installation scripts:

1. **butter-nvim.sh**: Installs Neovim and sets up JustAGuyLinux's configuration
2. **build-neovim.sh**: Builds and installs Neovim from source code

## Features

### butter-nvim.sh
- Installs Neovim using the pre-built Debian package from the repo
- Sets up JustAGuyLinux's Neovim configuration
- Automatically installs required plugins on first launch
- Backs up any existing Neovim configuration
- User-friendly installation process with visual feedback

### build-neovim.sh
- Builds the latest stable Neovim directly from source code
- Creates a Debian package and installs it
- Provides a vanilla Neovim installation without any custom configuration
- Better performance with optimized build options
- Access to the very latest Neovim features

## Requirements
- Linux-based operating system
- Git for cloning the repository
- sudo privileges for package installation
- Additional build dependencies (for build-neovim.sh)

## Installation
To set up Butter Neovim:
```bash
# Clone repository
git clone https://github.com/drewgrif/butterscripts.git

# Navigate to neovim directory
cd butterscripts/neovim

# Make scripts executable
chmod +x butter-nvim.sh build-neovim.sh

# Run either the configuration installer
./butter-nvim.sh

# OR build from source
./build-neovim.sh
```

## Which Script Should I Use?

- **Use butter-nvim.sh if:**
  - You want JustAGuyLinux's pre-configured Neovim setup
  - You prefer a quick and easy installation
  - You want plugins and settings already configured

- **Use build-neovim.sh if:**
  - You want the latest vanilla Neovim without any custom configuration
  - You prefer to set up your own configuration from scratch
  - You need performance optimizations from building from source
  - You want to ensure you have the absolute latest version

## How It Works

### butter-nvim.sh:
1. Downloads the pre-built Neovim Debian package
2. Installs it on your system
3. Backs up any existing Neovim configuration
4. Sets up JustAGuyLinux's Neovim configuration
5. Configures Neovim to automatically install required plugins on first launch

### build-neovim.sh:
1. Installs all necessary build dependencies
2. Clones the Neovim repository from GitHub
3. Builds Neovim from source with optimized settings
4. Creates a Debian package
5. Installs the package on your system

## Project Info
Made for Linux users who want simple Neovim installation options.

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
