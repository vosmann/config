#!/bin/bash

orig_dir=`pwd`
for git_dir in `find . -type d -iname ".git"`; do
    dir=${git_dir::-4} # trim the last part of the path (.git)
    echo EXAMINING: $dir

    cd $dir
    git status
    read -rsp $'Press any key to continue...\n' -n1 key

    cd $orig_dir
    echo
done
