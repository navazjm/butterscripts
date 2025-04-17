# 🧈 butterscripts

A modular collection of scripts I use across my Debian setups — minimal and practical. These scripts automate installs, configure tools, apply theming, and tweak the system just how I like it.

---

## Overview

Butterscripts is a collection of utility scripts that help streamline various tasks in Linux. These scripts are organized into different directories based on their functionality and purpose, making it easy to find the script you need.

## Repository Structure

The repository is organized into the following directories:

### `/browsers`

- [README](https://github.com/drewgrif/butterscripts/tree/main/browsers)
- **firefox**: Firefox latest
- **vivaldi**: Vivaldi
- **zen**: Zen browser
- **more**

---

### `/discord` 

Scripts for Discord installation. Access these scripts at [https://github.com/drewgrif/butterscripts/discord](https://github.com/drewgrif/butterscripts/discord).

### `/desktop`

Scripts related to desktop environments and window managers.

- **themes**: Scripts for installing and configuring themes
- **keyboard**: Keyboard shortcuts and configuration scripts
- **menu**: Menu generation and configuration scripts
- **display**: Scripts for managing displays and monitor setup

### `/media`

Media handling scripts.

- **audio**: Scripts for audio manipulation and management
- **video**: Video conversion and processing scripts
- **image**: Image manipulation tools

### `/network`

Networking related scripts.

- **wifi**: Scripts for managing WiFi connections
- **firewall**: Firewall configuration scripts
- **sharing**: Network file sharing utilities

### `/utilities`

General utility scripts.

- **file_management**: Scripts for file organization and management
- **text_processing**: Text manipulation utilities
- **time_savers**: Productivity enhancing scripts

## 📁 Project Structure

| Directory | Purpose | Example Scripts \& Descriptions |
| :-- | :-- | :-- |
| `browsers/` | Application installs and user-facing tools | `firefox-latest.sh` (latest Firefox), `librewolf-install.sh` (LibreWolf), etc. |
| `discord/` | Discord installation | `butterdis.sh` ([https://github.com/drewgrif/butterscripts/discord](https://github.com/drewgrif/butterscripts/discord) |
| `theming/` | Desktop theming and GTK configuration | `install-theme.sh` (Orchis GTK \& Colloid icons), `gtk-settings.sh` (GTK theming), `nerdfonts.sh` (JetBrainsMono Nerd Font) |

---

## Usage

Most scripts can be executed directly after making them executable:

```bash
chmod +x script_name.sh
./script_name.sh
```

Some scripts may require root privileges or additional configuration.

## Requirements

- Linux-based operating system (tested on Debian-based distributions)
- Bash shell
- Various dependencies as required by individual scripts

## Contributing

Contributions are welcome! If you have scripts that would fit well in this collection, please feel free to submit a pull request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

Thanks to all contributors and the open source community for inspiration and code references.
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
