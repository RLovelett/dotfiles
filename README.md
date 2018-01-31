# Installation

    cd $HOME
    git clone https://github.com/zsh-users/antigen.git .antigen
    make link

# Fedora

    dnf install -y util-linux-user
    chsh --shell /bin/zsh

    git clone https://github.com/arcticicestudio/nord-tilix.git
    cd nord-tilix
    ./install.sh

## Setup Yubikey

[ssh-gpg-smartcard-config for YubiKey 4 and YubiKey NEO](https://github.com/fedora-infra/ssh-gpg-smartcard-config/blob/d50a352eaa1dd047b00c296e607d75acb73e2adb/YubiKey.rst)

# Configuration

    mkdir -p $HOME/Source
    cd $HOME/Source

    # Install the iTerm2 themes
    git clone https://github.com/mbadolato/iTerm2-Color-Schemes.git
    # Solarized Dark Higher Contrast

    # Install the fonts
    git clone https://github.com/powerline/fonts.git
    cd fonts
    ./install.sh

    # Install Powerline
    # First install PIP
    sudo easy_install pip
    # Now install powerline
    pip install --user powerline-status
