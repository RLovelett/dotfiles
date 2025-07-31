# Vi mode cursor indicators
export ZSH_TMUX_MODE_FILE="${XDG_RUNTIME_DIR:-/tmp}/zsh_vi_mode_$$"

function zle-line-init {
  echo -ne "\e[5 q" # beam cursor on startup (insert mode)
  echo "INSERT" >| "$ZSH_TMUX_MODE_FILE"
}

# Change cursor shape for different vi modes
function zle-keymap-select {
  case $KEYMAP in
    vicmd)
      echo -ne '\e[1 q' # block cursor for normal mode
      echo "NORMAL" >| "$ZSH_TMUX_MODE_FILE"
      ;;
    viins|main)
      echo -ne '\e[5 q' # beam cursor for insert mode
      echo "INSERT" >| "$ZSH_TMUX_MODE_FILE"
      ;;
  esac
  zle reset-prompt
}

function zle-line-finish {
  echo "INSERT" >| "$ZSH_TMUX_MODE_FILE"
}

# Register the functions with ZLE
zle -N zle-line-init
zle -N zle-keymap-select
zle -N zle-line-init

# Reduce ESC delay (make vi mode more responsive)
export KEYTIMEOUT=1
