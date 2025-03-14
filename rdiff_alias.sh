#!/bin/bash

chmod +x rdiff.sh

set_rdiff() {
	echo "alias rdiff='bash $(pwd)/rdiff.sh'" >> $1
	source $1
}

if [ -f ~/.bashrc ]; then
	set_rdiff ~/.bashrc
fi

if [ -f ~/.bash_profile ]; then
	set_diff ~/.bash_profile
fi
