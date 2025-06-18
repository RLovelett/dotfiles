# ~/.zprofile — login-only environment setup
for f in "${ZDOTDIR:-$HOME}/.config/zsh/env.d/"*.zsh; do
  [[ -r $f ]] && source "$f"
done