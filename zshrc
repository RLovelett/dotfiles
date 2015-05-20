source ~/.antigen/antigen.zsh

# Support for colors
export TERM="xterm-256color"

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Git related buundles
antigen bundle git

# Node related bundles
antigen bundle node
antigen bundle npm

# Ruby related bundles
antigen bundle rake
antigen bundle rvm
antigen bundle bundler

# Generic bundles
antigen bundle command-not-found

if [[ $CURRENT_OS == 'OS X' ]]; then
    antigen bundle brew
    antigen bundle brew-cask
    antigen bundle osx
fi

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme https://github.com/RLovelett/bullet-train-oh-my-zsh-theme bullet-train

# Configure Bullet-Train
BULLETTRAIN_PROMPT_CHAR="👾 "

# Tell antigen that you're done.
antigen apply
