# ~/.zprofile — login-only environment setup
for f in "${ZDOTDIR:-$HOME}/.config/zsh/login.d/"*.zsh; do
  if [[ -r $f ]]; then
    source "$f"
  fi
done
