# 🧈 butterscripts

A curated collection of lightweight, practical scripts used in my Debian-based setups — especially Butter Bean Linux. These scripts handle everything from installing browsers to setting up fonts, printers, and display managers.

## 📁 Included Scripts

### 🔧 System Setup

- `add_bashrc.sh` – Appends custom `.bashrc` content
- `bluetooth.sh` – Bluetooth service setup and helpers
- `lightdm.sh` – LightDM configuration (with Arctica theme, if desired)
- `printers.sh` – Installs CUPS and common printer tools

### 🌐 Browsers

- `firefox-latest.sh` – Installs the latest Firefox binary
- `librewolf-install.sh` – Installs LibreWolf from binaries
- `discord.sh` – Installs Discord from the latest tarball

### 💻 Apps & Tools

- `geany-projects.sh` – Auto-setup for Geany project folders
- `nerdfonts.sh` – Installs Nerd Fonts (JetBrainsMono by default)
- `neovim.sh` – Installs the latest Neovim `.deb` and optionally clones my config

## 🚀 Usage

Clone the repo and run any script you need:

```bash
git clone https://github.com/drewgrif/butterscripts ~/butterscripts
cd ~/butterscripts
chmod +x *.sh  # optional, if needed
./firefox-latest.sh
```

You can also use them in your post-install workflow or drop them into an ISO build setup.

## 🧩 Designed For

- Butter Bean (butterbian) Linux 🧈.  We'll see.  LOL.
- Any Debian-based distro (Bookworm or newer recommended)
- Minimal setups with custom WMs (Openbox, BSPWM, etc.)

## 🌐 Links

- [YouTube: JustAGuy Linux](https://youtube.com/@JustAGuyLinux)
- [My Neovim Config](https://github.com/drewgrif/nvim)
