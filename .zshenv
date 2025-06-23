# ~/.zshenv — minimal environment (always sourced)
for f in "${ZDOTDIR:-$HOME}/.config/zsh/env.d/"*.zsh; do
  [[ -r $f ]] && source "$f"
done
