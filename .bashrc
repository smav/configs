###############################################################################
#
#  .bashrc for bash-2.05a (or later)
#
###############################################################################
#
#  This file is sourced by .bash_profile, plus interactive bash (sub)shells.
#
#  The actual ~/.bashrc should be a link to a git local repository,
#  it depends on other files in the repository.
#  i.e.             ~/.bashrc       ---> ~/.dotfiles/.bashrc
#                   ~/.bash_profile ---> ~/.dotfiles/.bash_profile
#                                   ---> ~/.dotfiles/common_aliases.sh
#                                   ---> ~/.dotfiles/functions.sh
#
# We also source config from ~/.bashrc.local if it exists,
# CREATE IT to store local config/aliases (keep it out of git).
#
#
# ----
# 
#  NB this file should *GENERATE NO OUTPUT* or it will break scp etc.
#               (that goes for any file it sources!)
#
# ----
#
# Advanced bash tips: http://samrowe.com/wordpress/advancing-in-the-bash-shell/
#
#     cd - 			# cd to previous dir
#     !!			# run last command
#     !$   			# last argument of last command
#
# cat a b | sort | uniq > c        # c is a union b
# cat a b | sort | uniq -d > c     # c is a intersect b
# cat a b b | sort | uniq -u > c   # c is set difference a - b
###############################################################################


###############################################################################
# Sanity check to avoid the 'generate no output' warning above about scp etc
# If not running interactively bail out
[ -z "$PS1" ] && return

###############################################################################
# Bash configuration options

export HOSTFILE='/etc/hosts'       # Use /etc/hosts for host name completion
shopt -s autocd                    # change to named directory
shopt -s cdable_vars               # if cd arg is not valid, assumes its a var defining a dir
shopt -q -s cdspell                # Auto-fix minor typos in interactive use of 'cd'
shopt -q -s checkwinsize           # Update the values of LINES and COLUMNS
shopt -q -s cmdhist                # Make multi-line commands 1 line in history
set -o notify   # (or set -b)      # Immediate notification of bckgrnd job termintn.
shopt -s huponexit                 # stops hang on exit
shopt -s dotglob                   # globs dot files
shopt -s nocaseglob                # pathname expansion will be treated as case-insensitive
#shopt -s expand_aliases            # expand aliases
shopt -s checkwinsize              # fix for putty resize/cmd line overwrite?
set show-all-if-ambiguous on       # tab once for name completion possibilities
#set -o noclobber                   # dont clobber files with > >>
#set -o ignoreeof                   # Dont let CTRL-D exit the shell
complete -d cd                     # tab only searches for dirs when using cd
ulimit -S -c 0 > /dev/null 2>&1    # No core files by default. See /etc/security/limits.conf
# Disable options:
shopt -u mailwarn
unset MAILCHECK                    # dont want shell to warn of incoming mail

# Bash VI mode, use VI keybinds for shell movement, 
# the standard keybindings are EMACS-like, ie ctrl-a ctrl-e
set -o vi


###############################################################################
# PATH, MANPATH & Host specific vars

BASE_PATH="/usr/sbin:/usr/local/bin:/usr/bin:/sbin:/bin"
PATH="${HOME}/.dotfiles/bin:${BASE_PATH}"
export PATH
#export CDPATH='.:..:../..:~/:/etc' # Similar to $PATH, but for use by 'cd'
# Note that the '.' in $CDPATH is needed so that cd will work under POSIX mode
# but this will also cause cd to echo the new directory to STDOUT!
#CDPATH=
#MANPATH="/usr/local/man:/usr/share/man:/usr/local/share/man:/usr/X11R6/man"
#export MANPATH #CDPATH


###############################################################################
# Default bit-mask
umask 0022
# Stricter perms for root
if [ "${USER}" == "root" ] ; then
    umask 0077
fi


###############################################################################
# Editor/pager

# Use Vim if available, vi if not
VIM_PATH=$(command -v vim)
# -n tests for string not empty, which is the default, but lets be explicit
if [ -n "${VIM_PATH}" ]; then
    # set vi alias
    alias vi="${VIM_PATH}"
else
	VIM_PATH="$(command -v vi)"
fi
EDITOR=${VIM_PATH}
VISUAL=${VIM_PATH}
export EDITOR VISUAL

# Pager - less > more
PAGER=$(command -v less)
if [ -n "${PAGER}" ]; then
    #Less - https://www.topbug.net/blog/2016/09/27/make-gnu-less-more-powerful/
    #export LESS='--quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4'
    # or the short version
    export LESS='-F -i -J -M -R -W -x4 -X -z-4'

    export LESSCHARSET="utf-8" # man formatting
    export LESSHISTFILE="/dev/null" # dont save search history
    #export LC_CTYPE="en_GB.UTF-8"
    #export LC_MESSAGES="en_GB.UTF-8"
    #export LESSCHARSET="en_GB.UTF-8"
else
    PAGER=$(command -v more)
fi
export PAGER

# Handle custom inputrc
for file in "${HOME}/.inputrc" /etc/inputrc; do
    [ -r "${file}" ] && export INPUTRC="${file}" && break # Use first found
done

case $- in
    *i*)    # interactive shell
        bind Space:magic-space # space show completions for !$ and !!, ie "!$ "
    ;;
esac


###############################################################################
# History
HISTSIZE=10000              # Num. of commands in history stack in memory
HISTFILESIZE=10000
#unset HISTFILESIZE                 # No limit on history file
HISTCONTROL=ignoreboth      # bash < 3, omit dups & lines starting with space
HISTIGNORE='&:[ ]*:ll:ls:exit' # bash >= 3, omit dups & lines starting with space, and common cmds
HISTTIMEFORMAT="%F %T "     # set this to get timings in history !
shopt -s histappend                # Append rather than overwrite history on exit
HISTFILE="${HOME}/.bash_history"  # Set a specific file to store history

# Separate historys in active terminals but all commands as typed
# (After each command just save history, dont reload it)
PROMPT_COMMAND="history -a"
# Shared history across all shell/tmux sessions
# (After each command, save and reload history)
#export PROMPT_COMMAND="history -a $HISTFILE; history -c; history -r $HISTFILE"


###############################################################################
# Bash completion

# Import bash tab completion settings, if they exist in the default location.
# This can take a second or two on a slow system, so you may not always
# want to do it, even if it does exist
[ -r /etc/bash_completion ] && source /etc/bash_completion

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[[ -e "${HOME}/.ssh/config" ]] \
  && complete \
       -o "default" \
       -o "nospace" \
       -W "$(grep "^Host" "${HOME}/.ssh/config" \
           | grep -v "[?*]" \
           | cut -d " " -f2)" \
       scp sftp ssh
# Store remote host config in .ssh/config it plays nicer with other commands


###############################################################################
# Colors

# Set ls colors
if [ -f "${HOME}/.dir_colors" ]; then
    eval "$(dircolors -b ${HOME}/.dir_colors)"
else
    eval "$(dircolors -b)"
fi
# Make grep search highlight yellow instead of red
export GREP_COLOR="1;33"

# man/less colors
export LESS_TERMCAP_mb=$'\E[01;37m'    # begin blinking
export LESS_TERMCAP_md=$'\E[01;37m'    # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # end mode
export LESS_TERMCAP_se=$'\E[0m'        # end standout mode
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin standout mode - infobox
export LESS_TERMCAP_ue=$'\E[0m'        # end underline
export LESS_TERMCAP_us=$'\E[01;33m'    # begin underline


##############################################################################
# Source the rest of our config

. "${HOME}/.dotfiles/common_aliases.sh" || \
    printf "Can't source ${HOME}/.dotfiles/common_aliases.sh\n"
. "${HOME}/.dotfiles/functions.sh"  || \
    printf "Can't source ${HOME}/.dotfiles/functions.sh\n"

# Host specific config, keep out of git
[[ -f "${HOME}/.bashrc.local" ]] && . "${HOME}/.bashrc.local"


##############################################################################
# SSH agent - re-use any existing agent for tmux/bash convenience
#
# ! Could be considered a security risk, remove this section on live boxes !

# Re-use exist ssh-agent
#
# Store ssh-agent output/config somewhere
AGENT_ENV="${HOME}/.ssh/.env"

start_agent() {
    # Start the agent and store it's details
    /usr/bin/ssh-agent | sed '/^echo/d' > "${AGENT_ENV}" && chmod 600 "${AGENT_ENV}"
    # Source it/make it active (ie nuke any old config)
    . "${AGENT_ENV}" > /dev/null
    # Add keys, this will throw up password prompts if the keys have them
    /usr/bin/ssh-add;
}

if [ -f "${AGENT_ENV}" ]; then
    # Is the ssh-agent setup, ie did we inherit one? (from Tmux/DisplayMgr/etc)
    if [ -n "${SSH_AUTH_SOCK}" ]; then
        # sudo can inherit other users auth_sock so.. check for this
        # (this check may be debian specific)
        if [ $(echo "${SSH_AUTH_SOCK}" | cut -d/ -f4) == "${EUID}" ]; then
            # The socket exists, but if the PID isn't running then it may be old
            # config, so start a new one/nuke it
            ps aux | grep ${SSH_AGENT_PID} 2>&1 | grep [s]sh-agent > /dev/null || start_agent
        fi
    else
        # No agent running, is there a config to use?
        if [ -f "${AGENT_ENV}" ]; then
            . "${AGENT_ENV}" > /dev/null
            # Is this a current agent, ie still running? If not, start a new one/nuke it
            ps aux | grep ${SSH_AGENT_PID} | grep [s]sh-agent > /dev/null || start_agent
        else
            # No agent running and no config to use, start the agent
            # (unless user is root, more caution is required for root)
            if [ "${EUID}" -ne 0 ]; then
                start_agent
            fi
        fi
    fi
fi

# gnupg for pass?
# start gnupg agent or read the details if its started
#if [ -f "~/.gpg-agent-info" ]; then
#if [ -x /usr/bin/gpg-agent ]; then
#   if /usr/bin/pgrep -u "${USER}" gpg-agent >/dev/null 2>&1; then
#       # gpgp-agent running source the file
#       . "~/.gpg-agent-info"
#       export GPG_AGENT_INFO
#       export SSH_AUTH_SOCK
#   else
#       # if gpg-agent not already running start it and write a file
#       eval $(gpg-agent --daemon --enable-ssh-support --write-env-file "~/.gpg-agent-info")
#   fi
#fi

##############################################################################
# End

# Setprompt from ~/.dotfiles/functions.sh
setprompt

################# End of ~/.bashrc (~/.dotfiles/.bashrc)  ######################
##############################################################################
