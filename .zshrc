# The `.zshrc` is for _interactive_ shell configuration.
#
# Things that should be in this file include:
#
#   1. Calls to `setopt` or `unsetopt` to configure the interactive shell
#   2. Load shell modules
#   3. Set your history options
#   4. Change the prompt
#   5. Set up completion, et cetera.
#   6. Set any variables that are only used in the interactive shell (e.g. $LS_COLORS).

# ZSH Unplugged
# https://github.com/mattmc3/zsh_unplugged
# where do you want to store your plugins?
ZPLUGINDIR="${XDG_DATA_HOME:-${HOME}/.local/share}/zsh_unplugged.git"

# get zsh_unplugged and store it with your other plugins
if [ ! -d "$ZPLUGINDIR" ]; then
  mkdir -p "$(dirname $ZPLUGINDIR)"
  git clone --quiet https://github.com/mattmc3/zsh_unplugged $ZPLUGINDIR
fi
source "$ZPLUGINDIR/antidote.lite.zsh"

# List of the Oh-My-Zsh plugins
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
#
# From https://github.com/mattmc3/zsh_unplugged/issues/8
# OMZ expects a list named 'plugins' so we can't use that variable name for
# repos, it can only contain the names of actual OMZ plugins.
plugins=(
  # A Zsh framework as nice as a cool summer breeze
  # https://github.com/mattmc3/zephyr
  mattmc3/zephyr/plugins/prompt

  # Additional completion definitions for Zsh
  # https://github.com/zsh-users/zsh-completions
  zsh-users/zsh-completions

  # Fish shell like syntax highlighting for zsh
  # https://github.com/zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-syntax-highlighting
)

# List of the Zsh plugins I use
prompts=(
  # Load Powerlevel10k theme
  # https://github.com/romkatv/powerlevel10k
  romkatv/powerlevel10k
)

# now load your plugins
plugin-clone $plugins $prompts
plugin-load --kind fpath $prompts
plugin-load $plugins

# Load completions
autoload -U compinit && compinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
prompt powerlevel10k
[[ ! -f ${ZDOTDIR:-$HOME}/.p10k.zsh ]] || source ${ZDOTDIR:-$HOME}/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
