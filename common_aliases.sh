##############################################################################
#
#  Bash Aliases - sourced by ~/.bashrc
#
##############################################################################

# Make sudo work with aliases
alias sudo='sudo '

# Reload shell config with "XX"
alias XX='. ~/.bash_profile'

# Safety
alias chown='chown --preserve-root'
alias chwon='chown --preserve-root' #spelling
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias rm='rm -I --preserve-root' #dont prompt if deleting more than 3 files

# Spelling/ack-grep if available
if [ -x '/usr/bin/ack-grep' ]; then
	alias ack-grep='/usr/bin/ack-grep -i --color'
	alias ack='/usr/bin/ack-grep -i --color'
	alias grep='/usr/bin/ack-grep -i --color'
	alias grpe='/usr/bin/ack-grep -i --color'
	alias gerp='/usr/bin/ack-grep -i --color'
	alias rgep='/usr/bin/ack-grep -i --color'
else
	alias grep='grep --ignore-case --color=auto'
	alias grpe='grep --ignore-case --color=auto'
	alias gerp='grep --ignore-case --color=auto'
	alias rgep='grep --ignore-case --color=auto'
fi

# Common
alias cd..='cd ..'                      # common mistype
alias m='less'                          # lazy map
alias p="ps aux | grep -v grep | grep " # eg "p apache"

alias ls='ls --group-directories-first --color=always'
LSOPTS='-lhF --group-directories-first --color=always' # long format, human readablea, add indicators
alias ll="ls ${LSOPTS}"
alias la="ls ${LSOPTS} -A"
# alias lk="ls ${LSOPTS} -ASr" # sort by size
# alias lc="ls ${LSOPTS} -Acr" # sort by change time
# alias lu="ls ${LSOPTS} -Aur" # sort by access time
# alias lt="ls ${LSOPTS} -At"  # sort by date
# alias ltr="ls ${LSOPTS} -Atr" # sort by date reversed

## End of Aliases
