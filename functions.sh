###############
# Functions - for including in .bashrc

# Set Colors
BLACK="\[\033[0;30m\]"
LBLACK="\[\033[1;30m\]"
GREY="\[\033[0;37m\]"
LGREY="\[\033[0;37m\]" # same as GREY otherwise its white
WHITE="\[\033[1;37m\]"

CYAN="\[\033[0;36m\]"
LCYAN="\[\033[1;36m\]"
RED="\[\033[0;31m\]"
LRED="\[\033[1;31m\]"
GREEN="\[\033[0;32m\]"
LGREEN="\[\033[1;32m\]"

YELLOW="\[\033[0;33m\]"
LYELLOW="\[\033[1;33m\]"
BLUE="\[\033[0;34m\]"
LBLUE="\[\033[1;34m\]"
MAGENTA="\[\033[0;35m\]"
LMAGENTA="\[\033[1;35m\]"
RES="\[\033\[0m\]"
NOCOLOUR="\[\033[0m\]"
NC="\[\033[0m\]"

function virtualenv_info  # get python venv prompt info
{
    # Get Virtual Env
    if [[ -n "$VIRTUAL_ENV" ]]; then
        # Strip out the path and just leave the env name
        venv="${VIRTUAL_ENV##*/}"
    else
        # In case you don't have one activated
        venv=''
    fi
	#[[ -n "$venv" ]] && echo "(venv:$venv)"
	[[ -n "$venv" ]] && echo "(venv)"
}

function setprompt        # setup a nicer prompt, color based on hostname
{
    USER=`who -m| cut -f1 -d" "| uniq`
    HOST=`hostname -s`

    # Prompt color depends on hostname
    case ${HOST} in
        kali)
            COLOR=${YELLOW}
            UCOLOR=${YELLOW}
            LCOLOR=${YELLOW}
            ;;
        vm*|*vm|diskless|debian*|centos*)
            COLOR=${GREEN}
            UCOLOR=${GREEN}
            LCOLOR=${LGREEN}
            ;;
        *)
            COLOR=${GREY}
            UCOLOR=${GREY}
            LCOLOR=${LGREY}
            ;;
    esac

    # Deal with the user type
    CHAR="$"
    ID=`id -u`
    # if user is root we need to change prompt sign and color
    if [ ${ID} -eq 0 ]; then
        CHAR="#"
        UCOLOR=${LRED}
    fi

    # set variable identifying the chroot you work in (used in the prompt below)
    if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
    fi

    PS1="${COLOR}┌${LCOLOR}(${UCOLOR}\u${GREY}@${COLOR}\h${LCOLOR})${COLOR}─${LCOLOR}(${COLOR}\t${LCOLOR})\n\
${COLOR}└${LCOLOR}(${COLOR}${deb_chroot:+($debian_chroot)}\w${LCOLOR})${COLOR}─${UCOLOR}${WHITE}\$(virtualenv_info)${UCOLOR}\${CHAR}${NC} "

    PS2="${COLOR}─${COLOR}─${LCOLOR}>${NC} "

} # End setprompt


function sshtips
{
less <<EOF

================================================
Tunnelling:

ssh -f user@personal-server.com -L 2000:personal-server.com:25 -N

    tunnel localhost:2000 to personal-server.com:25

ssh -f -L 3000:talk.google.com:5222 home -N

    tunnel localhost:3000 to talk.google.com:5222 thru home

Reverse Tunnel:

1. Create a tunnel from middle to target and leave it open when you are still at the office. You cn also ask your colleague at the office to do this. The below command will open port 12000 on middle for listening and forward all request on port 12000 on middle to port 22 of target

    * user@target $ ssh -R 12000:localhost:22 middleuser@middle

2. Now you can access to port 12000 on middle from current and you will be forwarded to port 22 on target

    * user@current $ ssh targetuser@middle -p 12000

3. If somehow you cannot access, access middle first, then connect to port 12000 of localhost

    * user@current $ ssh middleuser@middle
    * user@middle $ ssh targetuser@localhost -p 12000

4. You are now in the target server

Another reverse tunnel example:

    ssh -nNT -R 1100:local.mydomain.com:1100 remote.mydomain.com

What this does is initiate a connection to remote.mydomain.com and forwards TCP port 1100 on remote.mydomain.com to TCP port 1100 on local.mydomain.com. The "-n" option tells ssh to associate standard input with /dev/null, "-N" tells ssh to just set up the tunnel and not to prepare a command stream, and "-T" tells ssh not to allocate a pseudo-tty on the remote system. These options are useful because all that is desired is the tunnel and no actual commands will be sent through the tunnel, unlike a normal SSH login session. The "-R" option tells ssh to set up the tunnel as a reverse tunnel.

Now, if anything connects to port 1100 on the remote system, it will be transparently forwarded to port 1100 on the local system.
EOF
}
