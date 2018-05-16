if [[ -v TILIX_ID && -f /etc/profile.d/vte.sh ]]
then
  source /etc/profile.d/vte.sh
fi

if [[ -e "$HOME/.iterm2_shell_integration.zsh" ]]
then
  source "$HOME/.iterm2_shell_integration.zsh"
fi

# Support for colors
export TERM="xterm-256color"

# Make LESS/git aware of Emoji!
export LESSCHARSET=utf-8

# Load aliases
source $HOME/.aliases

## Use GPG for SSH
## Run my GPG-Agent
## https://github.com/fedora-infra/ssh-gpg-smartcard-config/blob/master/YubiKey.rst
## https://stackoverflow.com/a/26759734
if [[ -x "$(command -v gconftool-2)" && "$(gconftool-2 --get /apps/gnome-keyring/daemon-components/ssh)" != "false" ]]
then
  gconftool-2 --type bool --set /apps/gnome-keyring/daemon-components/ssh false
fi

case "$OSTYPE" in
  linux*)
    GPG_AGENT_ENV=/run/user/$(id -u)/gpg-agent.env
    if [[ ! -f "$GPG_AGENT_ENV" ]]
    then
      killall --quiet gpg-agent
      eval $(gpg-agent --daemon --enable-ssh-support > "$GPG_AGENT_ENV");
    fi
    source "$GPG_AGENT_ENV"
    ;;
esac
