MANIFEST=bash_aliases bash_login bash_profile profile bashrc gitconfig gvimrc.after rvmrc vimrc.after zshenv zshrc aliases tigrc

all: link
	@@echo "Build completed:"
	@@date

link:
	@@for file in ${MANIFEST}; do \
		ln -s `pwd`/$$file ~/.$$file; \
	done;

clean:
	@@for file in ${MANIFEST}; do \
		rm -f ~/.$$file; \
	done;
