if [[ -v TILIX_ID && -f /etc/profile.d/vte.sh ]]
then
  source /etc/profile.d/vte.sh
fi

if [[ -e "$HOME/.iterm2_shell_integration.zsh" ]]
then
  source "$HOME/.iterm2_shell_integration.zsh"
fi

# Make LESS/git aware of Emoji!
export LESSCHARSET=utf-8

# Load aliases
source $HOME/.aliases

case "$OSTYPE" in
  darwin*)
    export GPG_TTY=$(tty)
    export SSH_AUTH_SOCK="$HOME/.gnupg/S.gpg-agent.ssh"
    ## macOS GPG Keychain
    if [[ ! -S "$HOME/.gnupg/S.gpg-agent.ssh" ]]
    then
      local GPG_AGENT=$(PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/MacGPG2/bin" command -v gpg-agent)
      eval $($GPG_AGENT --homedir $HOME/.gnupg --daemon --quiet)
    fi
    ;;
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
