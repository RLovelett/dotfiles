# Load aliases
source $HOME/.aliases

# Load Antigen
source $HOME/.antigen/antigen.zsh

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

#if [[ $CURRENT_OS == 'OS X' ]]; then
antigen bundle brew
antigen bundle brew-cask
antigen bundle osx
antigen bundle robbyrussell/oh-my-zsh plugins/xcode

export EDITOR=$(which vim)
#fi

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# History Substring Search
antigen bundle zsh-users/zsh-history-substring-search

# Load Powerline Status
export PATH=$PATH:$HOME/Library/Python/2.7/bin
POWERLINE_ROOT=$HOME/Library/Python/2.7/lib/python/site-packages
. $POWERLINE_ROOT/powerline/bindings/zsh/powerline.zsh

# Tell antigen that you're done.
antigen apply
