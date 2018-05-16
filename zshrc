# Load Antigen
if [[ -a /usr/local/share/antigen/antigen.zsh ]] ; then
  source /usr/local/share/antigen/antigen.zsh
else
  source $HOME/.antigen/antigen.zsh
fi

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
    antigen bundle osx
    antigen bundle robbyrussell/oh-my-zsh plugins/xcode
    antigen bundle robbyrussell/oh-my-zsh plugins/docker
    export EDITOR=$(which vim)
    ;;
esac

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# History Substring Search
antigen bundle zsh-users/zsh-history-substring-search

# Load my custom agnoster theme
antigen theme https://github.com/RLovelett/agnoster-zsh-theme.git agnoster
# Comment line above and uncomment below when developing
# antigen theme $HOME/Source/agnoster-zsh-theme agnoster --no-local-clone

# Tell antigen that you're done.
antigen apply
