#!/usr/bin/env bash

MANIFEST=(bash_aliases bash_login bash_profile profile bashrc gitconfig gvimrc.after rvmrc vimrc.after zshenv zshrc aliases tigrc p10k.zsh)

function existing {
	local array=("$@")
	for file in "${array[@]}"
	do
		echo "Checking $HOME/.$file"
		if [[ -f "$HOME/.$file" ]]
		then
			echo "$HOME/file already existed."
			mv "$HOME/file" "$HOME/file.orig"
		fi
	done
}

function link {
	local array=("$@")
	for file in "${array[@]}"
	do
		echo "Linking $HOME/.$file"
		ln -s "$PWD/$file" "$HOME/.$file"
	done
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
link "${MANIFEST[@]}"
# clean "${MANIFEST[@]}"