# Dotfiles Repository

This repository contains configuration files and scripts for configuring my
desktop environment on macOS and Linux. The configurations are easily managed
using GNU Stow, a symlink farm manager that simplifies the process of keeping
dotfiles in order.

## Package Structure

The repository is organized into the following packages:

- **base/** - Core shell configurations (`.aliases`, `.zshrc`, `.zshenv`, `.gitconfig`, etc.)
- **config-common/** - Cross-platform XDG configurations (`.config/nvim/`, `.config/tmux/`, `.config/pyenv/`, `.config/Code/`, etc.)
- **config-linux/** - Linux-specific configurations (Hyprland, Waybar, Rofi, Tilix, `.gitconfig.local`)
- **config-macos/** - macOS-specific configurations (iTerm2, `.gitconfig.local`)
- **vscode-macos/** - macOS VS Code path (`Library/Application Support/Code/`)
- **macos-services/** - macOS system services (`Library/LaunchAgents/`)
- **ssh/** - SSH configuration (`.ssh/`)
- **local/** - Local user data (`.local/`)

## Requirements

The repository uses GNU Stow to manage configuration files. Before installing the dotfiles, the following tools must be present:

- `git`
- `stow`
- `zsh`

Install them with:

**Ubuntu/Debian:**
```bash
apt install --yes git stow zsh
```

**Arch Linux:**
```bash
pacman -S git stow zsh
```

**macOS (Homebrew):**
```bash
brew install git stow zsh
```

## Clone Repository

Clone the repository:

```bash
mkdir -p $HOME/Source
cd $HOME/Source
git clone --recurse-submodules --jobs $(nproc) https://github.com/RLovelett/dotfiles.git
cd dotfiles
```

## Prepare XDG Base Directory

XDG Base Directory specification folders are used by applications to organize configuration, cache, data, and state files. The following command creates the standard directories with default values if the environment variables are not already set:

```bash
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
mkdir -p $XDG_CONFIG_HOME $XDG_CACHE_HOME $XDG_DATA_HOME $XDG_STATE_HOME $HOME/.local/{,s}bin
```

## Install Configuration using Stow

This repository uses GNU Stow with platform-specific packages for cross-platform compatibility.

**For macOS:**
```bash
stow --target $HOME --verbose base config-common config-macos local ssh macos-services vscode-macos
```

**For Linux:**
```bash
stow --target $HOME --verbose base config-common config-linux ssh local
```

## Uninstall Configuration

**For macOS:**
```bash
stow --delete --target $HOME --verbose base config-common config-macos local ssh macos-services vscode-macos
```

**For Linux:**
```bash
stow --delete --target $HOME --verbose base config-common config-linux ssh local
```

## Configuration Details

The main `.gitconfig` includes platform-specific overrides via:
```ini
[include]
    path = ~/.gitconfig.local
```

## YubiKey, SSH, GnuPG Configuration on macOS

This section is primarily derived from Kirill Kuznetsov's article on [securing
macOS with YubiKey, SSH, and
GnuPG](https://evilmartians.com/chronicles/stick-with-security-yubikey-ssh-gnupg-macos).
The setup involves using `launchctl` to manage background services critical for
secure operations. Below are the commands used to setup and verify the
configuration:

### Setup Commands

```bash
launchctl load -F $HOME/Library/LaunchAgents/sh.brew.gnupg.gpg-agent.plist
launchctl load -F $HOME/Library/LaunchAgents/sh.brew.gnupg.link-ssh-auth-socket.plist
```

### Verification Commands

```bash
$ launchctl list | grep sh.brew.gnupg
-	0	sh.brew.gnupg.gpg-agent
-	0	sh.brew.gnupg.link-ssh-auth-sock

$ pgrep -fl gpg-agent
50890 gpg-agent --homedir /Users/lovelettr/.gnupg --use-standard-socket --daemon

$ ssh-add -L
ssh-rsa AAAAB3NzaC...5UNE54ZNTQ== cardno:5413447
```

For additional script management tips using `launchd` on macOS, visit [Apple's
guide on script management with
launchd](https://support.apple.com/guide/terminal/script-management-with-launchd-apdc6c1077b-5d5d-4d35-9c19-60f2397b2369/mac).

## Quick Links

- [macOS Setup Guide](https://github.com/RLovelett/dotfiles/wiki/macOS)
- [Linux Setup Guide (Ubuntu & Fedora)](https://github.com/RLovelett/dotfiles/wiki/Linux)
- [GNU Stow documentation](https://www.gnu.org/software/stow/manual/stow.html)
- [![Stow has forever changed the way I manage my dotfiles](https://img.youtube.com/vi/y6XCebnB9gs/0.jpg)](https://www.youtube.com/watch?v=y6XCebnB9gs)
