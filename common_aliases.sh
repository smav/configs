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

[[ -x /usr/bin/tree ]] && alias tree='tree -C --charset utf-8 --dirsfirst'

# Debian
if [ -f /etc/debian_version ]; then
	alias aupdate='sudo apt update -o Acquire::http::AllowRedirect=false'
	alias aupgrade='sudo apt upgrade -o Acquire::http::AllowRedirect=false'
	alias ainstall='sudo apt install'
	alias asearch='sudo apt search'
fi

# Misc
alias timestamp='date "+%Y%m%d"'
alias colors256='for i in {0..255}; do echo -e "\e[38;05;${i}m${i}"; done | column -c 80 -s " "; echo -e "\e[m"'
[ -x '/sbin/tune2fs' ] && alias boxage="sudo tune2fs -l $(df -h / |(read; awk '{print $1; exit}')) | grep -i created"
[ -x '/usr/bin/iostat' ] && alias diskio='/usr/bin/iostat -kd 5' # iftop, atop, dstat also good for system info

# VMs
alias vmls='sudo virsh list --all'
alias virls='virsh --connect qemu:///system list --all'

# Disk
alias sortsize='du -sh ./* | sort -hr | head -n 30 '
alias mountt='mount | column -t'    # nice output for mount command
alias disks='echo "╓───── m o u n t . p o i n t s"; echo "╙────────────────────────────────────── ─ ─ "; lsblk -a; echo ""; echo "╓───── d i s k . u s a g e"; echo "╙────────────────────────────────────── ─ ─ "; df -h;'

# Net
alias ports='netstat tulpn'
alias pubip='curl canhazip.com'
alias header='curl -I' # get web server headers
alias headerc='curl -I --compress' # does webserver support gzip/mod_deflate
alias speedtest1='wget -O /dev/null http://appldnld.apple.com.edgesuite.net/content.info.apple.com/Safari3/061-5806.20081124.bOHxyj/SafariSetup.exe'
alias speedtest2='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip'
[ -x '/usr/bin/nload' ] && alias netmon='nload -i 800 -o 400 -u K -t 1000 eth0'
# also iftop, bmon etc for net bandwidth, dnstop for dns lookups
alias ds='dig +noauthority +noadditional +noqr +nostats +noidentify +nocmd +noquestion +nocomments'
[ -x '/usr/bin/tcpdump' ] && alias tcpdumpfile='sudo tcpdump -i any -s 65535 -w '

#GW=`route -n | grep ^0.0.0.0 | awk '{print $2}'`
GW=$(ip route | grep default | cut -f3 -d" ")
# Common troubleshooting pings
alias pinggw='ping ${GW}'           # ping next hop
alias ping4='ping 4.2.2.2'
alias ping8='ping 8.8.8.8'
alias pingg='ping www.google.com'

# iptables
alias ipt='sudo /sbin/iptables'
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfwd='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'

# pptp debug
#alias gredump='sudo tcpdump -i eth0 -s 0 tcp port 1723 or proto 47'

# Utility
alias makecert='openssl req -new -x509 -keyout server.pem -out server.pem -days 3650 -nodes'

# Kali/HTB
alias vpn='openvpn --config ~/htb/htb.ovpn'
alias pyhttp='python -m SimpleHTTPServer 8000'
alias ipme='sudo dhclient eno1'

## End of Aliases
