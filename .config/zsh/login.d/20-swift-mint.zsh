# Mint Swift Package Manager
: ${MINT_ROOT:="$HOME/.mint"}
if [[ -d "$MINT_ROOT/bin" ]]; then
  path=("$MINT_ROOT/bin" $path)
fi
