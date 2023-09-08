# The `.zshenv` is always sourced (and before `.zshrc`).
#
# Things that should be in this file include:
#
#   1. For example, $PATH, $EDITOR, and $PAGER are often set in .zshenv.

export HOMEBREW_ANALYTICS_DEBUG=1
export HOMEBREW_NO_ANALYTICS=1

# Make LESS/git aware of Emoji!
export LESSCHARSET=utf-8

# Only try and use Java Home if it can be found
if [[ -x /usr/libexec/java_home ]]
then
  export JAVA_HOME=$(/usr/libexec/java_home --version 1.8)
fi

# Set EDITOR
if command -v editor 1>/dev/null 2>&1
then
  export EDITOR=$(command -v editor)
  export VISUAL=$EDITOR
fi

# Load NPM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add pyenv init to my shell
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Add pyenv virtualenv-init to enable auto-activation of virtualenvs
if command -v pyenv-virtualenv-init 1>/dev/null 2>&1; then
  eval "$(pyenv virtualenv-init -)"
fi

# Set PATH so it includes user's private bin if it exists
if [[ -d "$HOME/bin" ]]
then
  export PATH="$HOME/bin:$PATH"
fi

# Set PATH so it includes user's private bin if it exists
if [[ -d "$HOME/.local/bin" ]]
then
  export PATH="$HOME/.local/bin:$PATH"
fi

case "$OSTYPE" in
  linux*)
    ## Use GPG for SSH on Linux
    ## Run gpg-agent using Systemd as described in this post
    ## https://eklitzke.org/using-gpg-agent-effectively
    if [[ -S "$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh" && -z "$SSH_AUTH_SOCK" ]]
    then
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh"
    fi

    if [[ -z "$DISPLAY" ]]
    then
      export GPG_TTY=$(tty)
    fi
    ;;
esac
