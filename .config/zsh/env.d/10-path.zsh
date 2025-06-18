# Add user-local bin directories to PATH
for d in "$HOME/bin" "$HOME/.local/bin" "$HOME/.mint/bin"; do
  [[ -d $d ]] && path=("$d" $path)
done