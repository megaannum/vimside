#!/bin/bash

declare -a repos=( 
"git://github.com/megaannum/self.git" 
"git://github.com/megaannum/forms.git" 
"git://github.com/Shougo/vimproc.git"
"git://github.com/Shougo/vimshell.git"
"-b scala-2.9 git://github.com/aemoncannon/ensime.git"
"git://github.com/megaannum/vimside.git"
)

cd ~/.vim/bundle
for repo in "${repos[@]}"; do
    git clone $repo 
done;

cd vimproc
make -f make_unix.mak
