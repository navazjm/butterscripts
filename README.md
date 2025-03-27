# 🧈 butterscripts

A personal collection of scripts used across my Debian setups — minimal, modular, and made to pair with [Butter Bean Linux](https://butterbeanlinux.com). These scripts automate installs, apply system tweaks, and handle theming and configuration.

## 🗂️ Script Categories

### ⚙️ System Setup

- `add_bashrc.sh` – Appends custom `.bashrc` settings
- `bluetooth.sh` – Installs and configures Bluetooth support
- `lightdm.sh` – Sets up LightDM and applies Arctica greeter theme
- `printers.sh` – Installs CUPS and common printer drivers
- `nerdfonts.sh` – Installs JetBrainsMono Nerd Font

### 🌐 Browser & Comms

- `firefox-latest.sh` – Installs latest Firefox binary
- `librewolf-install.sh` – Installs LibreWolf via `.deb`
- `discord.sh` – Installs Discord manually from the tarball

### 🖥 Terminals & Tools

- `wezterm.sh` – Installs latest WezTerm `.deb` and config
- `fastfetch.sh` – Builds and installs Fastfetch + config from `jag_dots`
- `neovim.sh` – Installs Neovim from `.deb` and offers my config
- `geany-projects.sh` – Creates quick-start project structure for Geany

### 🎨 Appearance

- `install-theme.sh` – Installs Orchis GTK and Colloid icon themes

## 🚀 Getting Started

Clone the repo and run scripts manually:

```bash
git clone https://github.com/drewgrif/butterscripts ~/butterscripts
cd ~/butterscripts
chmod +x *.sh  # if needed

./fastfetch.sh
./install-theme.sh
```

You can mix and match scripts for your own post-install workflow or custom Debian-based builds.

## 🧈 Designed For

- Butter Bean (butterbian)Linux (and other Debian-based systems).  This is a joke... for now.
- Tiling + floating WM setups (Openbox, BSPWM, etc.)
- Minimal users who want full control with clean defaults

## 📫 Author

**JustAGuy Linux**  
🎥 [YouTube](https://youtube.com/@JustAGuyLinux)  

---

More scripts coming soon. Use what you need, tweak what you want.
```

