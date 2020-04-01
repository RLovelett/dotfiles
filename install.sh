#!/usr/bin/env zsh

MANIFEST=(bash_aliases bash_login bash_profile profile bashrc gitconfig gvimrc.after rvmrc vimrc.after zshenv zshrc aliases tigrc p10k.zsh)

function existing {
	local array=("$@")
	for file in "${array[@]}"
	do
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
