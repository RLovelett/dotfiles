# Vi mode cursor and tmux status indicators
function _set_tmux_vi_mode {
  [[ -n ${TMUX_PANE:-} ]] || return
  tmux set-option -p -t "$TMUX_PANE" @zsh_vi_mode "$1" 2>/dev/null
  tmux refresh-client -S 2>/dev/null
}

function zle-line-init {
  echo -ne "\e[5 q" # beam cursor on startup (insert mode)
  _set_tmux_vi_mode INSERT
}

# Change cursor shape for different vi modes
function zle-keymap-select {
  case $KEYMAP in
    vicmd)
      echo -ne '\e[1 q' # block cursor for normal mode
      _set_tmux_vi_mode NORMAL
      ;;
    viins|main)
      echo -ne '\e[5 q' # beam cursor for insert mode
      _set_tmux_vi_mode INSERT
      ;;
  esac
  zle reset-prompt
}

function zle-line-finish {
  _set_tmux_vi_mode INSERT
}

# Register the functions with ZLE
zle -N zle-line-init
zle -N zle-keymap-select
zle -N zle-line-finish

# Reduce ESC delay (make vi mode more responsive)
export KEYTIMEOUT=1
