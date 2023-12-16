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

# Set the default text editor for various applications.
# First, try to find a command named 'editor'. This is typically managed by 'update-alternatives' on Debian-based systems
# where multiple text editors are installed and one is configured as the default using the 'update-alternatives' tool.
if command -v editor >/dev/null 2>&1
then
  export EDITOR=$(command -v editor)
  # If 'editor' is found, set it as the EDITOR, VISUAL, and GIT_EDITOR for consistent usage across applications.
elif command -v nvim >/dev/null 2>&1
then
  # If 'editor' is not found, check for 'nvim' (NeoVim).
  export EDITOR=$(command -v nvim)
elif [ -x "/opt/homebrew/bin/nvim" ]
then
  # If neither 'editor' nor 'nvim' in PATH, specifically check for 'nvim' installed via Homebrew on macOS.
  export EDITOR="/opt/homebrew/bin/nvim"
else
  # If none of the editors are found, output a reminder to install an editor.
  echo "No suitable editor found. Please install 'editor' or 'nvim'."
fi

# Set VISUAL and GIT_EDITOR to the same value as EDITOR.
export VISUAL=$EDITOR
export GIT_EDITOR=$EDITOR

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

# Use 1Passwords SSH Agent; if it is setup
if [[ -S "$HOME/.1password/agent.sock" ]]
then
  export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
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
