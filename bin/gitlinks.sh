#!/bin/bash
#
# Set symbolic links to git config files, backup any existing files

# Dir we cloned configs to
CFG_DIR="configs"
# List of files to link to (only top level ~/.dotfiles can be linked this way)
LIST=".bashrc .bash_profile .tmux.conf .inputrc .vimrc"

# Create dir/link files
if [ -d ${CFG_DIR} ]; then
    # Link all config files
    for file in ${LIST}; do
        if [ -L ~/${file} ] ; then
            printf "SymLink Exists... ~/${file}\n"
            :
        elif [ -f ~/${file} ]; then
            mv ~/${file} ~/${file}.mvd-gitlinks
            printf "Moving existing... ~/${file}\n"
            ln -s ${CFG_DIR}/${file} ~/${file}
            printf "Linking... ~/${file}\n"
        else
            ln -s ${CFG_DIR}/${file} ~/${file}
            printf "Linking... ~/${file}\n"
        fi
    done
else # no configs dir found
    echo  "No ${CFG_DIR} folder. Did you call it something else? ls -al ~/configs ?  update \${CFG_DIR} in this script.'"
    exit 1
fi

exit 0
