# Use GPG for SSH
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"

# Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.rvm/bin"

# Use Swift Preview
#export PATH=$HOME/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin:"${PATH}"

# Configure GO
export GOPATH=$HOME/Source/go
export PATH="${PATH}":$GOPATH/bin

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

if [[ $TERMINIX_ID ]]; then
  source /etc/profile.d/vte.sh
fi

## Run my GPG-Agent
## https://github.com/fedora-infra/ssh-gpg-smartcard-config/blob/master/YubiKey.rst
if [ ! -f /run/user/$(id -u)/gpg-agent.env ]; then
    killall gpg-agent;
    eval $(gpg-agent --daemon --enable-ssh-support > /run/user/$(id -u)/gpg-agent.env);
fi
. /run/user/$(id -u)/gpg-agent.env

# Load aliases
source $HOME/.aliases

# Make LESS/git aware of Emoji!
export LESSCHARSET=utf-8

# Load Antigen
if [[ -a /usr/local/share/antigen/antigen.zsh ]] ; then
  source /usr/local/share/antigen/antigen.zsh
else
  source $HOME/.antigen/antigen.zsh
fi

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
