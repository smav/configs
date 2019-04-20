#!/bin/bash
#
# Set symbolic links to git config files, backup any existing files
# useful for quick box setup

# Dir we cloned configs to
CFG_DIR="${HOME}/configs"
# List of files/dirs to link to (only top level of config can be linked this way)
LIST=".bashrc .bash_profile .tmux.conf .inputrc" # .fluxbox .irssi"

# Create dir/link files
if [ -d "${CFG_DIR}" ]; then
    # Link all config files
    for file in ${LIST}; do
        target="${HOME}/${file}"
        mvd="${target}.mvd-gitlinks"

        if [ -L "${target}" ] ; then
            printf "SymLink Exists... %s\n" "${target}"
            :
        elif [ -f "${target}" ]; then
            printf "Moving existing... %s\n" "${target}"
            mv "${target}" "${mvd}"
            printf "Linking... %s\n" "${target}"
            ln -s "${CFG_DIR}/${file}" "${target}"
        else
            printf "Linking... %s\n" "${target}"
            ln -s "${CFG_DIR}/${file}" "${target}"
        fi
    done

    # Do .vim/.vimrc if it exists
    vimdir="${HOME}/.vim"
    if [ -d "${vimdir}" ]; then
        file=".vimrc"
        target="${HOME}/${file}"
        mvd="${target}.mvd-gitlinks"

        if [ -L "${target}" ] ; then
            printf "SymLink Exists... %s\n" "${target}"
            :
        elif [ -f "${target}" ]; then
            printf "Moving existing... %s\n" "${target}"
            mv "${target}" "${mvd}"
            printf "Linking... %s\n" "${target}"
            ln -s "${vimdir}/${file}" "${target}"
        else
            printf "Linking... %s\n" "${target}\n"
            ln -s "${vimdir}/${file}" "${target}"
        fi
    fi

else # no configs dir found
    echo  "No ${CFG_DIR} folder. Did you call it something else? ls -al ~/configs ?  update \${CFG_DIR} in this script.'"
    exit 1
fi

exit 0
