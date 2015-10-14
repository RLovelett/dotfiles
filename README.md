# Installation

    cd $HOME
    git clone https://github.com/zsh-users/antigen.git .antigen
    make link

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
