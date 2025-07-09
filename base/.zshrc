# The `.zshrc` is for _interactive_ shell configuration.
#
# Things that should be in this file include:
#
#   1. Calls to `setopt` or `unsetopt` to configure the interactive shell
#   2. Load shell modules
#   3. Set your history options
#   4. Change the prompt
#   5. Set up completion, et cetera.
#   6. Set any variables that are only used in the interactive shell (e.g. $LS_COLORS).
for f in "${ZDOTDIR:-$HOME}/.config/zsh/init.d/"*.zsh; do
  if [[ -r $f ]]; then
    source "$f"
  fi
done

# Load aliases
source $HOME/.aliases

# ZSH Unplugged
# https://github.com/mattmc3/zsh_unplugged
# where do you want to store your plugins?
ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}

# Source the plugin-load function
source "${ZPLUGINDIR}/rlovelett/plugin-load.zsh"

plugins=(
  # Ensure oh-my-posh is installed and configure the prompt accordingly
  rlovelett/oh-my-posh

  # A Zsh framework as nice as a cool summer breeze
  # https://github.com/mattmc3/zephyr
  mattmc3/zephyr/plugins/color
  mattmc3/zephyr/plugins/completion
  mattmc3/zephyr/plugins/directory
  rlovelett/environment
  rlovelett/history
  mattmc3/zephyr/plugins/utility

  # Oh My Zsh - an open source, community-driven framework for managing zsh
  # https://github.com/ohmyzsh/ohmyzsh
  ohmyzsh/ohmyzsh/lib/clipboard.zsh
  ohmyzsh/ohmyzsh/plugins/colored-man-pages
  ohmyzsh/ohmyzsh/plugins/magic-enter
  # The git plugin provides many aliases and a few useful functions.
  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
  ohmyzsh/ohmyzsh/plugins/git
  # This plugin provides a few utilities to make it more enjoyable on macOS.
  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/macos
  ohmyzsh/ohmyzsh/plugins/macos
  # This plugin provides a few utilities that can help you on your daily use of Xcode and iOS development.
  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/xcode
  ohmyzsh/ohmyzsh/plugins/xcode

  # Additional completion definitions for Zsh
  # https://github.com/zsh-users/zsh-completions
  zsh-users/zsh-completions

  # 🐠 Fish-like autosuggestions for zsh
  # https://github.com/zsh-users/zsh-autosuggestions
  zsh-users/zsh-autosuggestions

  rlovelett/fzf

  # Replace ZSH's default completion selection menu with fzf
  # https://github.com/aloxaf/FZF-tab
  Aloxaf/fzf-tab

  # 🐠 Fish shell like syntax highlighting for zsh
  # https://github.com/zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-syntax-highlighting

  # 🐠 ZSH port of Fish history search (up arrow)
  # https://github.com/zsh-users/zsh-history-substring-search
  zsh-users/zsh-history-substring-search
)

plugin-load $plugins

autoload -Uz compinit && compinit

# Keybindings
# Set the keymap to emacs
bindkey -e

# TODO: This does not seem to work...
#bindkey -M emacs '^y' autosuggest-accept

# Check if history-substring-search functions are available
# history-substring-search-up/down is provided by zsh-users/zsh-history-substring-search
if (( ${+functions[history-substring-search-up]} && ${+functions[history-substring-search-down]} )); then
    # Bind keys if the substring search plugin is loaded
    bindkey '^[[A' history-substring-search-up
    bindkey -M emacs '^P' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    bindkey -M emacs '^N' history-substring-search-down
else
    # Default bindings if the plugin is not loaded
    bindkey '^[[A' history-search-backward
    bindkey -M emacs '^P' history-search-backward
    bindkey '^[[B' history-search-forward
    bindkey -M emacs '^N' history-search-forward
fi

# Completion styling
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with ls when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
#zstyle ':completion:*' matcher-list "m:{a-z}={A-Za-z}"

# Launch tmux by default
#if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#  tmux a -t default || exec tmux new -s default && exit;
#fi

bindkey "^[[3~" delete-char
