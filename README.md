# Dotfiles Repository

This repository contains configuration files and scripts for configuring my
desktop environment on macOS and Linux. The configurations are easily managed
using GNU Stow, a symlink farm manager that simplifies the process of keeping
dotfiles in order.

## Quick Links

- [macOS Setup Guide](https://github.com/RLovelett/dotfiles/wiki/macOS)
- [Linux Setup Guide (Ubuntu & Fedora)](https://github.com/RLovelett/dotfiles/wiki/Linux)
- [![Stow has forever changed the way I manage my dotfiles](https://img.youtube.com/vi/y6XCebnB9gs/0.jpg)](https://www.youtube.com/watch?v=y6XCebnB9gs)

## Clone and Prepare Repository

The repository uses GNU Stow to manage configuration files. Before installing the dotfiles, the following tools must be present:

- `git`
- `stow`
- `zsh`

Install them with:

```bash
apt install --yes git stow zsh
```

Clone the repository:

```bash
mkdir -p $HOME/Source
cd $HOME/Source
git clone --recurse-submodules --jobs $(nproc) https://github.com/RLovelett/dotfiles.git
cd dotfiles
```

## Make the XDG folder spec

XDG Base Directory specification folders are used by applications to organize configuration, cache, data, and state files. The following command creates the standard directories with default values if the environment variables are not already set:

```bash
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
mkdir -p $XDG_CONFIG_HOME $XDG_CACHE_HOME $XDG_DATA_HOME $XDG_STATE_HOME $HOME/.local/{,s}bin
```

## Install Configuration using Stow

GNU Stow is used to manage the dotfiles in this repository. It creates symlinks
from a cloned copy of the repository to a specified directory, making it easy
to manage and version control configuration files.

To "install" the configuration files in this repository using Stow, I typically
run the following command:

```bash
stow --target $HOME --verbose .
```

This command tells Stow to create symlinks in the `$HOME` directory for all
configuration files located in the current directory. For more detailed
information about GNU Stow and its capabilities, see the [GNU Stow
documentation](https://www.gnu.org/software/stow/manual/stow.html).

### Unstow

To remove the symlinks created by Stow, use the `--delete` flag:

```bash
stow --delete --target $HOME --verbose .
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
