###############################################################################
#
#  .bashrc for bash-2.05a (or later)
#
###############################################################################
#
# This file is sourced by .bash_profile, plus interactive bash (sub)shells.
#
#  The actual ~/.bashrc should be a link to a git local repository,
#  it depends on other files in the repository.
#  i.e.             ~/.bashrc       ---> ~/configs/.bashrc
#                   ~/.bash_profile ---> ~/configs/.bash_profile
#                                   ---> ~/configs/common_aliases.sh
#                                   ---> ~/configs/functions.sh
#
# We also source config from ~/.bashrc.local if it exists,
# CREATE IT to store local config/aliases (keep it out of git).
#
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#  N.B. this file should *GENERATE NO OUTPUT* or it will break scp etc.
#                 (that goes for any file it sources)
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# bash tips: http://samrowe.com/wordpress/advancing-in-the-bash-shell/
#
###############################################################################


###############################################################################
# Sanity check

# If not running interactively bail out. 
[ -z "$PS1" ] && return
# Sanity check to avoid the 'generate no output' warning above about scp etc

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
#set -o vi


###############################################################################
# PATH, MANPATH & Host specific vars

BASE_PATH="/usr/sbin:/usr/local/bin:/usr/bin:/sbin:/bin"
PATH="${HOME}/configs/bin:${BASE_PATH}"
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
for file in ~/.inputrc /etc/inputrc; do
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

# Separate histories in active terminals but all commands as typed
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


###############################################################################
# Colors

# Set ls colors
if [ -f "${HOME}/.dir_colors"  ]; then
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

. "${HOME}/configs/common_aliases.sh" || \
    printf "Can't source ${HOME}/configs/common_aliases.sh\n"
. "${HOME}/configs/functions.sh"  && setprompt || \
    printf "Can't source ${HOME}/configs/functions.sh\n"

# Host specific config, keep out of git
[[ -f "${HOME}/.bashrc.local" ]] && . "${HOME}/.bashrc.local"


##############################################################################
################# End of ~/.bashrc (~/configs/.bashrc)  ######################
##############################################################################
