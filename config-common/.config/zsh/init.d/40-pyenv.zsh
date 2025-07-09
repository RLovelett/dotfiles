# Pyenv (Python version manager)
export PYENV_ROOT="$XDG_CONFIG_HOME/.pyenv"
if [[ -d "$PYENV_ROOT/bin" ]]; then
  path=("$PYENV_ROOT/bin" $path)
fi
if command -v pyenv &>/dev/null; then
  eval "$(pyenv init -)"
fi
