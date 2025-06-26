# ~/.zprofile — login-only environment setup
echo "*************************************************************************"
echo "Loading .zshprofile"
print -l $path > ~/before.txt
echo "*************************************************************************"
# Loop through each .zsh file in the specified directory
for f in "${ZDOTDIR:-$HOME}/.config/zsh/login.d/"*.zsh; do
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
print -l $path > ~/after.txt
echo "*************************************************************************"
