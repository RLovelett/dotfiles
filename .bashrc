# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

export PHONE_GAP="$HOME/src/phonegap-android/bin"
export ANDROID_SDK="$HOME/src/android-sdk-mac_86"
export MY_BIN="$HOME/bin"
export PATH="$PHONE_GAP:$ANDROID_SDK/tools:$ANDROID_SDK/platform-tools:$MY_BIN:$PATH"

# Enables colorization of the ls command on Mac OSX
if [ `uname -s` == "Darwin" ]; then
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxEgedabagacad
fi

export HISTFILESIZE=3000
export HISTCONTROL=ignoredups

# Since mysql is not in Mac OSX by default need to alias it...
if [ `uname -s` == "Darwin" ]; then
alias mysql=/usr/local/mysql/bin/mysql
alias mysqladmin=/usr/local/mysql/bin/mysqladmin
fi

# enable color support of ls and also add handy aliases
alias dir='ls -lGh'

# Git aliases...
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias go='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'

alias got='git '
alias get='git '

# Gets the current branch from Git
parse_git_branch()
{
  git branch 2>/dev/null | grep -e '^*' | sed -E 's/^\* (.+)$/(\1) /'
}

# Delete all gems
alias remove-gems='gem list | cut -d" " -f1 | xargs gem uninstall -aIx'

#alias grep='grep --color=auto'
#alias fgrep='fgrep --color=auto'
#alias egrep='egrep --color=auto'
alias mountedinfo='df -hT'

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

is_mac()
{
  return `uname -s` == "Darwin"
}

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
