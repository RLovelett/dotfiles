# The `.zshenv` file is for _universal_ shell configuration. Minimal environment.
#
# This file is always sourced for every Zsh invocation, including:
#   - Login shells
#   - Interactive shells
#   - Non-interactive shells (scripts)
#
# Things that should be in this file include:
#
#   1. Exported environment variables that need to be available in all sessions
#      (e.g. PATH, LANG, LESSCHARSET).
#   2. Universal environment variables used by multiple applications.
#   3. Settings that should be inherited by any subshells or scripts.
#   4. Minimal configuration to avoid impacting shell performance.
#
# Note: Avoid placing interactive shell-specific settings or commands here,
#       as they might interfere with non-interactive shells or scripts.
echo "*************************************************************************"
echo "Loading .zshenv"
echo "*************************************************************************"
# Loop through each .zsh file in the specified directory
for f in "${ZDOTDIR:-$HOME}/.config/zsh/env.d/"*.zsh; do
  if [[ -r $f ]]; then
    # Use the time command to measure the time taken to source the file
    start_time=$(date +%s.%N)

    source "$f"

    end_time=$(date +%s.%N)

    elapsed_time=$(echo "$end_time - $start_time" | bc)

    # Print the file name and the elapsed time
    printf "Sourced: %s (Time taken: %s seconds)\n" "$f" "$elapsed_time"
  fi
done
print -l $path
echo "*************************************************************************"
