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

