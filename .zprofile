# ~/.zprofile — login-only environment setup
for f in "${ZDOTDIR:-$HOME}/.config/zsh/login.d/"*.zsh; do
  [[ -r $f ]] && source "$f"
done
