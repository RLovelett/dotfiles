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

# https://www.soberkoder.com/better-zsh-history/
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
export HISTTIMEFORMAT="[%F %T] "
export HISTFILE="${HOME}/.zsh_history"
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -v TILIX_ID && -f /etc/profile.d/vte.sh ]]
then
  source /etc/profile.d/vte.sh
fi

if [[ -e "${HOME}/.iterm2_shell_integration.zsh" ]]
then
  source "${HOME}/.iterm2_shell_integration.zsh"
fi

# Load aliases
source $HOME/.aliases

# ZSH Unplugged
# https://github.com/mattmc3/zsh_unplugged
# where do you want to store your plugins?
ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}

# get zsh_unplugged and store it with your other plugins
if [[ ! -d $ZPLUGINDIR/zsh_unplugged ]]; then
  git clone --quiet https://github.com/mattmc3/zsh_unplugged $ZPLUGINDIR/zsh_unplugged
fi
source $ZPLUGINDIR/zsh_unplugged/zsh_unplugged.plugin.zsh

# List of the Oh-My-Zsh plugins
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
#
# From https://github.com/mattmc3/zsh_unplugged/issues/8
# OMZ expects a list named 'plugins' so we can't use that variable name for
# repos, it can only contain the names of actual OMZ plugins.
plugins=(
  # The git plugin provides many aliases and a few useful functions.
  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
  git
  # This plugin provides a few utilities to make it more enjoyable on macOS.
  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/macos
  macos
  # This plugin provides a few utilities that can help you on your daily use of Xcode and iOS development.
  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/xcode
  xcode
  # This plugin adds auto-completion for docker.
  # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker
  docker
)

# List of the Zsh plugins I use
repos=(
  # Oh My Zsh - an open source, community-driven framework for managing zsh
  # https://github.com/ohmyzsh/ohmyzsh
  ohmyzsh/ohmyzsh

  # Load Powerlevel10k theme
  # https://github.com/romkatv/powerlevel10k
  romkatv/powerlevel10k

  # Fish-like autosuggestions for zsh
  # https://github.com/zsh-users/zsh-autosuggestions
  zsh-users/zsh-autosuggestions

  # Fish shell like syntax highlighting for zsh
  # https://github.com/zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-syntax-highlighting

  # 🐠 ZSH port of Fish history search (up arrow)
  # https://github.com/zsh-users/zsh-history-substring-search
  zsh-users/zsh-history-substring-search

  # A good set of Zsh keybindings, many of which are shamelessly borrowed from Prezto.
  # https://github.com/zshzoo/keybindings
  zshzoo/keybindings

  # A better Zsh history configuration
  # https://github.com/zshzoo/history
  zshzoo/history

  # Enable great Zsh options, because Zsh defaults are meh.
  # https://github.com/zshzoo/setopts
  zshzoo/setopts
)

# now load your plugins
plugin-load $repos

# Modified from https://news.ycombinator.com/item?id=16242955
# Also from https://stackoverflow.com/q/81272/247730
# Also from https://www.iterm2.com/faq.html - Q: How do I make the option/alt key act like Meta or send escape codes?
function echo_color() {
  local color="$1"
  printf "${color}$2\033[0m\n"
}
function shortcuts() {
  echo_color "\033[1;90m" "***Moving***"
  echo_color "\033[0;90m" "Ctrl-A — Backwards by line"
  echo_color "\033[0;90m" " Alt-B — Backwards by word"
  echo_color "\033[0;90m" "Ctrl-B — Backwards by character"
  echo_color "\033[0;90m" "Ctrl-E — Forwards by line"
  echo_color "\033[0;90m" " Alt-F — Forwards by word"
  echo_color "\033[0;90m" "Ctrl-F — Forwards by character"
  echo_color "\033[1;90m" "***Erasing***"
  echo_color "\033[0;90m" "Ctrl-W — Backwards by word"
  echo_color "\033[0;90m" "Ctrl-U — Backwards by line"
  echo_color "\033[0;90m" " Alt-D — Forwards by word"
  echo_color "\033[0;90m" "Ctrl-K — Forwards by line"
  echo_color "\033[1;90m" "***Miscellaneous***"
  echo_color "\033[0;90m" "Ctrl-T — Swap chars (useful for correcting typos)"
}
shortcuts

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
