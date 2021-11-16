#!/bin/bash
#
# Argument parsing via Argbash. See: http://argbash.readthedocs.io/ for more.
#
# ARG_OPTIONAL_SINGLE([skip], [s], [Skip writing a file into the \$HOME directory (e.g., --skip gitconfig)])
# ARG_HELP([Install all the dotfiles in the user's \$HOME directory.])
# ARGBASH_GO

# [ <-- needed because of Argbash

MANIFEST=(gitconfig gvimrc.after rvmrc vimrc.after tigrc p10k.zsh zprofile zshenv zshrc aliases)

if [[ -n "${_arg_skip}" ]]
then
	echo "Value of --skip: $_arg_skip"
	MANIFEST=("${MANIFEST[@]/$_arg_skip}")
	echo "Removed: ${MANIFEST[@]}"
fi

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
			mv "$HOME/.$file" "$HOME/.$file.orig"
			link "$file"
		else
			echo "$HOME/.$file does not exist"
			link "$file"
		fi
	done
}

function link {
	echo "Linking $HOME/.$file"
	ln -s "$PWD/$file" "$HOME/.$file"
}

function clean {
	local array=("$@")
	for file in "${array[@]}"
	do
		echo "Removing $HOME/.$file"
		rm -f "$HOME/.$file"
	done
}

existing "${MANIFEST[@]}"
# clean "${MANIFEST[@]}"

# ] <-- needed because of Argbash
