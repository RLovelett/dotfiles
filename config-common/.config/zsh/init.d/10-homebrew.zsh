# Homebrew environment setup
: ${HOMEBREW_PREFIX:=/opt/homebrew}
if [[ -x "$HOMEBREW_PREFIX/bin/brew" ]]; then
  export HOMEBREW_ANALYTICS_DEBUG=1
  export HOMEBREW_NO_ANALYTICS=1
  export HOMEBREW_CASK_OPTS="--appdir=$HOME/Applications"
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
fi
