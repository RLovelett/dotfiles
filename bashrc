# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

export PHONE_GAP="$HOME/src/phonegap-android/bin"
export ANDROID_SDK="$HOME/src/android-sdk-mac_86"
export MY_BIN="$HOME/bin"
export MYSQL_PATH="/usr/local/mysql/bin"
export PATH="$MYSQL_PATH:/usr/local/bin:$PHONE_GAP:$ANDROID_SDK/tools:$ANDROID_SDK/platform-tools:$MY_BIN:$PATH"

# For mysql2 gem on Mac OS X
if [ `uname -s` == "Darwin" ]; then
  export DYLD_LIBRARY_PATH="/usr/local/mysql/lib:$DYLD_LIBRARY_PATH"
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Enables colorization of the ls command on Mac OSX
if [ `uname -s` == "Darwin" ]; then
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxEgedabagacad
fi

# Gets the current branch from Git
parse_git_branch()
{
  git branch 2>/dev/null | grep -e '^*' | sed -E 's/^\* (.+)$/(\1) /'
}

# Testing colors
colors ()
{
  echo -e "${NC}COLOR_NC (No color)"
  echo -e "${WHITE}COLOR_WHITE\t${BLACK}COLOR_BLACK"
  echo -e "${BLUE}COLOR_BLUE\t${LIGHT_BLUE}COLOR_LIGHT_BLUE"
  echo -e "${GREEN}COLOR_GREEN\t${LIGHT_GREEN}COLOR_LIGHT_GREEN"
  echo -e "${CYAN}COLOR_CYAN\t${LIGHT_CYAN}COLOR_LIGHT_CYAN"
  echo -e "${RED}COLOR_RED\t${LIGHT_RED}COLOR_LIGHT_RED"
  echo -e "${PURPLE}COLOR_PURPLE\t${LIGHT_PURPLE}COLOR_LIGHT_PURPLE"
  echo -e "${YELLOW}COLOR_YELLOW\t${LIGHT_YELLOW}COLOR_LIGHT_YELLOW"
  echo -e "${GRAY}COLOR_GRAY\t${LIGHT_GRAY}COLOR_LIGHT_GRAY"
}

# Remove old kernels
rmkernel()
{
  local cur_kernel=$(uname -r|sed 's/-*[a-z]//g'|sed 's/-386//g')
  local kernel_pkg="linux-(image|headers|ubuntu-modules|restricted-modules)"
  local meta_pkg="${kernel_pkg}-(generic|i386|server|common|rt|xen|ec2)"
  sudo apt-get purge $(dpkg -l | egrep $kernel_pkg | egrep -v "${cur_kernel}|${meta_pkg}" | awk '{print $2}')
}

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm)          color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
    xterm-color)    color_prompt=yes;;
    cygwin)         color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
  export TERM="xterm-color"
  export NC='\033[0m'
  export WHITE='\033[1;37m'
  export BLACK='\033[0;30m'
  export BLUE='\033[0;34m'
  export LIGHT_BLUE='\033[1;34m'
  export GREEN='\033[0;32m'
  export LIGHT_GREEN='\033[1;32m'
  export CYAN='\033[0;36m'
  export LIGHT_CYAN='\033[1;36m'
  export RED='\033[0;31m'
  export LIGHT_RED='\033[1;31m'
  export PURPLE='\033[0;35m'
  export LIGHT_PURPLE='\033[1;35m'
  export YELLOW='\033[0;33m'
  export LIGHT_YELLOW='\033[1;33m'
  export GRAY='\033[1;30m'
  export LIGHT_GRAY='\033[0;37m'
  export PS1="\[${NC}\][\[${LIGHT_BLUE}\]\u\[${YELLOW}\]@\[${BLUE}\]\H\[${NC}\] \[${PURPLE}\]\w\[${NC}\]] \$(parse_git_branch)\n\[${GREEN}\]$ \[${NC}\]"
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w $(parse_git_branch)\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Load RVM if it available to be loaded
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function
