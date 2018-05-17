# Load Antigen
if [[ -a /usr/local/share/antigen/antigen.zsh ]] ; then
  source /usr/local/share/antigen/antigen.zsh
else
  source $HOME/.antigen/antigen.zsh
fi

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Git related buundles
antigen bundle git

# Node related bundles
antigen bundle node
antigen bundle npm

# Ruby related bundles
antigen bundle rake
antigen bundle rvm
antigen bundle bundler

# Generic bundles
antigen bundle command-not-found

case "$OSTYPE" in
  darwin*)
    antigen bundle brew
    antigen bundle osx
    antigen bundle robbyrussell/oh-my-zsh plugins/xcode
    antigen bundle robbyrussell/oh-my-zsh plugins/docker
    export EDITOR=$(which vim)
    ;;
esac

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# History Substring Search
antigen bundle zsh-users/zsh-history-substring-search

# Load my custom agnoster theme
antigen theme https://github.com/RLovelett/agnoster-zsh-theme.git agnoster
# Comment line above and uncomment below when developing
# antigen theme $HOME/Source/agnoster-zsh-theme agnoster --no-local-clone

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

# Tell antigen that you're done.
antigen apply
