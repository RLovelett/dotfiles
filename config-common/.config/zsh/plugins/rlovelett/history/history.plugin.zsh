# 16.2.4 History
setopt append_history          # Append history entries to the history file instead of overwriting.
setopt bang_hist               # Treat the '!' character specially during expansion.
setopt extended_history        # Write the history file in the ':start:elapsed;command' format.
setopt hist_expire_dups_first  # Expire a duplicate event first when trimming history.
setopt hist_find_no_dups       # Do not display a previously found event.
setopt hist_ignore_all_dups    # Delete an old recorded event if a new event is a duplicate.
setopt hist_ignore_dups        # Do not record an event that was just recorded again.
setopt hist_ignore_space       # Do not record an event starting with a space.
setopt hist_reduce_blanks      # Remove extra blanks from commands added to the history list.
setopt hist_save_no_dups       # Do not write a duplicate event to the history file.
setopt hist_verify             # Do not execute immediately upon history expansion.
unsetopt inc_append_history    # Disable, as SHARE_HISTORY includes this functionality.
setopt NO_hist_beep            # Don't beep when accessing non-existent history.
setopt share_history           # Don't share history between all sessions.

# $HISTFILE belongs in the data home, not with the ZSH configs
HISTFILE=${XDG_DATA_HOME:=$HOME/.local/share}/zsh/history
[[ -d $HISTFILE:h ]] || mkdir -p $HISTFILE:h

SAVEHIST=100000
HISTSIZE=20000

# Set Zsh aliases related to history.
alias hist='fc -li'
alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -nr | head"

