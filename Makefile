MANIFEST=bash_aliases bash_login bash_profile bashrc gitconfig gvimrc.after rvmrc vimrc.after conkyrc draw_bg.lua conkyForecast.config

all: link
	@@echo "Build completed:"
	@@date

link:
	@@for file in ${MANIFEST}; do \
		ln -s `pwd`/$$file ~/.$$file; \
	done;

clean:
	@@for file in ${MANIFEST}; do \
		rm ~/.$$file; \
	done;
