#!/bin/bash
#
# Argument parsing via Argbash. See: http://argbash.readthedocs.io/ for more.
#
# ARG_OPTIONAL_SINGLE([skip], [s], [Skip writing a file into the \$HOME directory (e.g., --skip gitconfig)])
# ARG_OPTIONAL_BOOLEAN([dry-run], [d], [Print the steps that would be taken without actually performing them.])
# ARG_OPTIONAL_BOOLEAN([debug],[],[Debug mode, increase verbosity further.])
# ARG_OPTIONAL_BOOLEAN([install-dotfiles], [i], [Install the dotfiles into the \$HOME directory.])
# ARG_OPTIONAL_BOOLEAN([uninstall-dotfiles], [u], [Remove the managed dotfiles from the \$HOME directory.])
# ARG_HELP([Install all the dotfiles in the user's \$HOME directory.])
# ARGBASH_GO

# [ <-- needed because of Argbash
shopt -s extglob
set -euo pipefail

MANIFEST=(gitconfig tigrc p10k.zsh zprofile zshenv zshrc aliases)

function is_dry_run {
	[ "$_arg_dry_run" = "on" ]
}

function existing {
	local array=("$@")
	for file in "${array[@]}"
	do
		if [[ -z ${file} ]]
		then
			continue
		fi
		echo "Checking $HOME/.$file"
		if [[ "$HOME/.$file" -ef "$PWD/$file" ]]
		then
			echo "$HOME/.$file already has the correct symlink."
		elif [[ -f "$HOME/.$file" ]]
		then
			echo "$HOME/.$file is a regular file"
			echo "Renaming $HOME/.$file to $HOME/.$file.orig"
			if ! is_dry_run; then mv "$HOME/.$file" "$HOME/.$file.orig"; fi
			link "$file"
		else
			echo "$HOME/.$file does not exist"
			link "$file"
		fi
	done
}

function link {
	echo "Linking $HOME/.$file"
	if ! is_dry_run; then ln -s "$PWD/$file" "$HOME/.$file"; fi
}

function clean {
	local array=("$@")
	for file in "${array[@]}"
	do
		echo "Removing $HOME/.$file"
		if ! is_dry_run; then rm -f "$HOME/.$file"; fi
	done
}

#If debug, print timestamps and every command run
if [[ ${_arg_debug} == "on" ]]; then
	set -xT
	set -o functrace
	PS4='+\t '
fi

if [[ ${_arg_install_dotfiles} == "on" ]]; then
	if is_dry_run
	then
		echo "NOTE: No file system changes will occur."
	fi

	if [[ -n "${_arg_skip}" ]]
	then
		echo "Value of --skip: $_arg_skip"
		MANIFEST=("${MANIFEST[@]/$_arg_skip}")
		echo "Removed: ${MANIFEST[@]}"
	fi

	existing "${MANIFEST[@]}"
fi

if [[ ${_arg_uninstall_dotfiles} == "on" ]]; then
	if is_dry_run
	then
		echo "NOTE: No file system changes will occur."
	fi

	if [[ -n "${_arg_skip}" ]]
	then
		echo "Value of --skip: $_arg_skip"
		MANIFEST=("${MANIFEST[@]/$_arg_skip}")
		echo "Removed: ${MANIFEST[@]}"
	fi

	clean "${MANIFEST[@]}"
fi

# ] <-- needed because of Argbash
