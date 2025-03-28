# 🧈 butterscripts

A modular collection of scripts I use across my Debian setups — minimal, practical, and built to pair with [Butter Bean Linux](https://butterbeanlinux.com). These scripts automate installs, configure tools, apply theming, and tweak the system just how I like it.

> Works great on Butter Bean Linux, but useful on any clean Debian install.

---

## 📁 Categories

### 🛠 system/

System-level setup and configuration.

- `add_bashrc.sh` – Appends custom `.bashrc` entries
- `bluetooth.sh` – Installs and configures Bluetooth support
- `lightdm.sh` – Sets up LightDM with Arctica greeter
- `printers.sh` – Installs CUPS and basic printer drivers

### 🌐 apps/

Binary installs and user-facing applications.

- `firefox-latest.sh` – Installs the latest Firefox tarball
- `librewolf-install.sh` – Installs LibreWolf `.deb`
- `discord.sh` – Installs Discord manually from tarball
- `wezterm.sh` – Installs WezTerm `.deb` and config
- `fastfetch.sh` – Builds Fastfetch from source and applies config
- `neovim.sh` – Installs Neovim `.deb` and my custom config

### 🧩 config/

Dev environment helpers.

- `geany-projects.sh` – Sets up project folder structure for Geany

### 🎨 theming/

Desktop theming and GTK configuration.

- `install-theme.sh` – Installs Orchis GTK and Colloid icon themes
- `gtk-settings.sh` – Applies GTK2/GTK3 theme and appearance settings
- `nerdfonts.sh` – Installs JetBrainsMono Nerd Font

---

## 🚀 Getting Started

Clone the repo and run what you need:

```bash
git clone https://github.com/drewgrif/butterscripts ~/butterscripts
cd ~/butterscripts

# Example usage:
./apps/wezterm.sh
./theming/install-theme.sh
./system/bluetooth.sh
```

---

## 🧈 Built For

- **Butter Bean Linux** (and other Debian-based systems)
- Window manager setups (BSPWM, Openbox, etc.)
- Users who like things lightweight, modular, and fast

> Butterbian Linux is a joke... for now.

---

## 📫 Author

**JustAGuy Linux**  
🎥 [YouTube](https://youtube.com/@JustAGuyLinux)  
🌐 [butterbeanlinux.com](https://butterbeanlinux.com) ・ [butterbian.com](https://butterbian.com)

---

More scripts coming soon. Use what you need, fork what you like, tweak everything.
```

---

Want me to generate a ready-to-upload structure with folders and this README in place?
