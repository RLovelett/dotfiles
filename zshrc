# Load aliases
source $HOME/.aliases

# Make LESS/git aware of Emoji!
export LESSCHARSET=utf-8

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

case "$OSTYPE" in
  darwin*)
    antigen bundle brew
    antigen bundle brew-cask
    antigen bundle brew
    antigen bundle osx
    antigen bundle robbyrussell/oh-my-zsh plugins/xcode
    export EDITOR=$(which vim)
    ;;
esac

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# History Substring Search
antigen bundle zsh-users/zsh-history-substring-search

# Load my custom agnoster theme
antigen theme https://gist.github.com/8b6cd39dfe1fe8b52517.git agnoster
# Comment line above and uncomment below when developing
# antigen theme $HOME/Source/agnoster agnoster --no-local-clone

# Tell antigen that you're done.
antigen apply

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

if [[ $TERMINIX_ID ]]; then
  source /etc/profile.d/vte.sh
fi
