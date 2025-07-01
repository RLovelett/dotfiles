# Set XDG base dirs.
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
LOCAL_HOME=${LOCAL_HOME:-$HOME/.local}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$LOCAL_HOME/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$LOCAL_HOME/state}
mkdir -p $XDG_CONFIG_HOME $XDG_CACHE_HOME $XDG_DATA_HOME $XDG_STATE_HOME $LOCAL_HOME/{,s}bin

# Add /usr/local/bin to path.
path=(/usr/local/{,s}bin(N) $path)

# Set the list of directories that Zsh searches for programs.
if [[ ! -v prepath ]]; then
  typeset -ga prepath
  # If path ever gets out of order, you can use `path=($prepath $path)` to reset it.
  prepath=(
    $HOME/{,s}bin(N)
    $HOME/.local/{,s}bin(N)
  )
fi
path=(
  $prepath
  /usr/local/{,s}bin(N)
  $path
)
