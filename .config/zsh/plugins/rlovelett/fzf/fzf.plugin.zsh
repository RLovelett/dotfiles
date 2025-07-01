# Set XDG_CONFIG_HOME with a default value if unset
: ${XDG_CONFIG_HOME:=$HOME/.config}

# Set FZF_BASE with a default value if unset
: ${FZF_BASE:=$XDG_CONFIG_HOME/fzf}

# Define the path to the fzf binary directory
: ${FZF_BIN:=$FZF_BASE/bin}

# Append fzf bin directory to the PATH if it exists and is not already included
if [[ -d "$FZF_BIN" && ":$PATH:" != *":$FZF_BIN:"* ]]; then
  export PATH="$PATH:$FZF_BIN"
fi

# Ensure FZF is installed
if ! command -v fzf > /dev/null 2>&1; then
  echo "fzf command not found, attempting to install."
  $FZF_BASE/install --bin --xdg
fi

# Source fzf key bindings and completion scripts for Zsh
# Check for zsh-defer availability and source accordingly
if (( $+functions[zsh-defer] )); then
  zsh-defer . "$FZF_BASE/shell/completion.zsh"
  zsh-defer . "$FZF_BASE/shell/key-bindings.zsh"
else
  . "$FZF_BASE/shell/completion.zsh"
  . "$FZF_BASE/shell/key-bindings.zsh"
fi

