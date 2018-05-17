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
