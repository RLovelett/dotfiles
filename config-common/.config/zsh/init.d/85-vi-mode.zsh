# Vi mode cursor indicators
# Change cursor shape for different vi modes
function zle-keymap-select {
  case $KEYMAP in
    vicmd) echo -ne '\e[1 q';;      # block cursor for normal mode
    viins|main) echo -ne '\e[5 q';; # beam cursor for insert mode
  esac
}

function zle-line-init {
  echo -ne "\e[5 q" # beam cursor on startup (insert mode)
}

# Register the functions with ZLE
zle -N zle-keymap-select
zle -N zle-line-init

# Reduce ESC delay (make vi mode more responsive)
export KEYTIMEOUT=1