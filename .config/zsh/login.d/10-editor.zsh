# Detect default editor for EDITOR, VISUAL, and GIT_EDITOR
detect_editor() {
  local candidates=(editor nvim "$HOMEBREW_PREFIX/bin/nvim" vim vi nano)
  for e in "${candidates[@]}"; do
    if [[ -x $e ]] || command -v $e &>/dev/null; then
      echo $e
      return
    fi
  done
}
export EDITOR="$(detect_editor)"
export VISUAL="$EDITOR"
export GIT_EDITOR="$EDITOR"
