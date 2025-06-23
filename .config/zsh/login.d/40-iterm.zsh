# iTerm2 integration
if [[ "$OSTYPE" == darwin* && -r "$XDG_CONFIG_HOME/iterm2/integration.zsh" ]]; then
  source "$XDG_CONFIG_HOME/iterm2/integration.zsh"
fi
