# PATH configuration and management
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
