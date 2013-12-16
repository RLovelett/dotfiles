# Git related aliases
alias gs='git status '
alias ga='git add '
alias gap='git add -p'
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias go='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'

# Experimental Git Aliases
# Suggested from Huffshell
alias gr='git rebase'
alias gri='git rebase -i'
alias gri='git rebase -i'
alias grim='git rebase -i master'
alias grim='git rebase -i master'
alias gr-='git rebase --continue'
alias gst='git stash'
alias gc-='git commit --amend'

alias got='git '
alias get='git '

# Delete all gems
alias remove-gems='gem list | cut -d" " -f1 | xargs gem uninstall -aIx'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Copy with progress
# http://fauxzen.com/add-a-progress-bar-to-copy-command-in-linux/
alias cpp='rsync --progress -ah'

# sshuttle
# http://elasticdog.com/2011/12/use-sshuttle-to-keep-safe-on-insecure-wi-fi/
alias tunnel='sshuttle --dns --daemon --pidfile=/tmp/sshuttle.pid --remote=lovelett.me 0/0'
alias tunnelx='[[ -f /tmp/sshuttle.pid ]] && kill $(cat /tmp/sshuttle.pid) && echo "Disconnected."'

# Oh toodles!
alias oh='ssh'
