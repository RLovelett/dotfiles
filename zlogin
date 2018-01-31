
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

if [[ $TERMINIX_ID ]]; then
  source /etc/profile.d/vte.sh
fi

if [[ $(gconftool-2 --get /apps/gnome-keyring/daemon-components/ssh) != "false" ]]; then
  gconftool-2 --type bool --set /apps/gnome-keyring/daemon-components/ssh false
fi

if [ ! -f /run/user/$(id -u)/gpg-agent.env ]; then
    killall gpg-agent;
    eval $(gpg-agent --daemon --enable-ssh-support > /run/user/$(id -u)/gpg-agent.env);
fi
. /run/user/$(id -u)/gpg-agent.env
