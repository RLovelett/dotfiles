# Function: plugin-load
# Description:
#   Dynamically loads zsh plugins from specified plugin directories. It ensures that
#   the plugin directories are correctly set up and sources the initialization files.
#   Supports deferred loading with `zsh-defer` if available.
#
# Usage:
#   plugin-load [repository1] [repository2] ...
#   Each argument should be a repository name that corresponds to a directory
#   within $ZPLUGINDIR. Each repository name should match the directory name
#   of the plugin under the plugin directory.
#
# Parameters:
#   repository1, repository2, ... - List of repositories corresponding to plugin directories.
#
# Examples:
#   plugin-load zsh-users/auto-suggestions zsh-users/syntax-highlighting
function plugin-load {
  local name plugindir initfile initfiles=()
  : ${ZPLUGINDIR:=${ZDOTDIR:-$HOME/.config/zsh}/plugins}

  for repo in $@; do
  # Check if the path is fully qualified and ends with a known plugin extension
  if [[ "$repo" == *.* && "$repo" =~ \.(zsh|sh|zsh-theme|plugin.zsh)$ ]]; then
  initfile=$ZPLUGINDIR/$repo
  if [[ ! -e $initfile ]]; then
  echo >&2 "Error: Plugin file '$initfile' not found."
  continue
  fi
  else
  name=${repo:t}
  plugindir=$ZPLUGINDIR/$repo
  initfile=$plugindir/$name.plugin.zsh

  if [[ ! -d $plugindir ]]; then
  echo >&2 "Error: '$plugindir' not found."
  continue
  fi

  if [[ ! -e $initfile ]]; then
  initfiles=($plugindir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
  if (( $#initfiles == 0 )); then
  echo >&2 "Error: No ZSH plugin files found in '$plugindir'."
  continue
  fi
  initfile=$initfiles[1] # Set initfile to the first found init file
  fi
  fi

  # Check for zsh-defer availability and source accordingly
  if (( $+functions[zsh-defer] )); then
  zsh-defer . $initfile
  else
  . $initfile
  fi
  done
}
