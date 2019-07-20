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

function parse_git_branch # Git prompt helpers
{
    # some chars for ref : ● ✖ ✔ ✚ … ⚑ ▶

    # Set colors
    GRED="\033[0;31m"
    GLRED="\033[1;31m"
    GYELLOW="\033[0;33m"
    GGREEN="\033[0;32m"
    GNC="\033[0m"

    # https://gist.github.com/738048
    # https://gist.github.com/634750
    #git rev-parse --git-dir &> /dev/null
    local repo=$(git rev-parse --show-toplevel 2> /dev/null)
    if [[ ! -e "$repo" ]]; then
        # do not process further if not in a git controlled directory
        return
    fi
    local git_status="$(git status 2> /dev/null)"

    # NEW - more advanced git status
    # from https://github.com/magicmonty/bash-git-prompt
    local -a git_status_fields
    git_status_fields=( $(~/configs/bin/git_status.sh 2>/dev/null) )
    local GIT_BRANCH=${git_status_fields[0]}
    local GIT_REMOTE=${git_status_fields[1]}
    local GIT_UPSTREAM=${git_status_fields[2]}
    local GIT_STAGED=${git_status_fields[3]}
    local GIT_CONFLICTS=${git_status_fields[4]}
    local GIT_CHANGED=${git_status_fields[5]}
    local GIT_UNTRACKED=${git_status_fields[6]}
    local GIT_STASHED=${git_status_fields[7]}
    local GIT_CLEAN=${git_status_fields[8]}

    #branch_pattern="^# On branch ([^${IFS}]*)"
    local branch_pattern="^On branch ([^${IFS}]*)"
    local detached_branch_pattern="# Not currently on any branch"
    local remote_pattern="# Your branch is (.*) of"
    local diverge_pattern="# Your branch and (.*) have diverged"
    #if [[ ! ${git_status}} =~ "working tree clean" ]]; then
    local state=""
    if [[ ${GIT_CLEAN} -eq 1 ]]; then
        state="${GGREEN}✔ "
    #else
    fi

    local remote=""
    if [[ ${GIT_REMOTE} =~ "AHEAD" ]]; then
        local ahead_count=$(echo ${GIT_REMOTE} | cut -d_ -f3)
        remote="${GYELLOW}↑${ahead_count} "
    elif [[ ${GIT_REMOTE} =~ "BEHIND" ]]; then
        local behind_count=$(echo ${GIT_REMOTE} | cut -d_ -f3)
        remote="${GYELLOW}↓${behind_count} "
    # TODO: fix the below when you have an example to work with
    elif [[ ${git_status} =~ ${diverge_pattern} ]]; then
        remote="${GYELLOW}↕ "
    fi

  #  #if [[ ${git_status} =~ ${remote_pattern} ]]; then
  #  #    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
  #  #        remote="${GYELLOW}↑"
  #  #    else
  #  #        remote="${GYELLOW}↓"
  #  #    fi
  #  #fi

    local details=""
    if [[ ${GIT_STAGED} -gt 0 ]]; then
        details="${GNC} | ${GYELLOW}● ${GIT_STAGED} "
    fi
    if [[ ${GIT_CHANGED} -gt 0 ]]; then
        if [[ ${#details} -gt 0 ]]; then
            details="${details}${GYELLOW}✚ ${GIT_CHANGED}"
        else
            details="${GNC} | ${details}${GYELLOW}✚ ${GIT_CHANGED}"
        fi
    fi
    if [[ ${GIT_UNTRACKED} == "^" || ${GIT_UNTRACKED} -gt 0 ]]; then
        details="${details}${GRED} …${GIT_UNTRACKED}"
    fi

    local branch=""
    if [[ ${git_status} =~ ${branch_pattern} ]]; then
        # Remove color codes/special chars, from commandlinefu.com
        local branchname=$(echo ${BASH_REMATCH[1]} | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g")
        branch="${GGREEN}[${branchname}]"
    elif [[ ${git_status} =~ ${detached_branch_pattern} ]]; then
        branch="${GYELLOW}[--NO BRANCH--]"
    fi

    local s=""
    if [[ ${#state} -gt "0" || ${#remote} -gt "0" ]]; then
        s=" "
    fi
    if [[ ${branch} != "" ]]; then
        echo -e " ${branch}${s}${state}${remote}${details}"
    fi
}

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

    # added for kali workflow, host_ip display
    [[ -f ./host_ip ]] && IP=$(cat ./host_ip) && IP="${IP}─"

    # Prompt color depends on hostname
    case ${HOST} in
        lupus)
            COLOR=${CYAN}
            UCOLOR=${CYAN}
            LCOLOR=${LCYAN}
            ;;
        tao|kali|debian*|buster*|vm*|*vm)
            COLOR=${YELLOW}
            UCOLOR=${YELLOW}
            LCOLOR=${YELLOW}
            ;;
        diskless|net)
            COLOR=${GREEN}
            UCOLOR=${GREEN}
            LCOLOR=${LGREEN}
            ;;
        bigjessie|node*|pve*)
            COLOR=${RED}
            UCOLOR=${RED}
            LCOLOR=${LRED}
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

    # Get tty info
    local temp=$(tty)
    local TTY=${temp:1}

    # set variable identifying the chroot you work in (used in the prompt below)
    if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
    fi

    PS1="${COLOR}┌\
${LCOLOR}(${UCOLOR}\u${GREY}@${COLOR}\h${LCOLOR})${COLOR}\
${COLOR}─${IP}${LCOLOR}(${COLOR}\t${LCOLOR})${COLOR}${NC}\
\$(parse_git_branch)\n\
${COLOR}└${LCOLOR}(${COLOR}${deb_chroot:+($debian_chroot)}\w${LCOLOR})${COLOR}─${UCOLOR}${WHITE}\$(virtualenv_info)${UCOLOR}\${CHAR}${NC} "

    PS2="${COLOR}─${COLOR}─${LCOLOR}>${NC} "

} # End setprompt

function newmac           # generate VM MAC address
{
    MACADDR="52:54:$(dd if=/dev/urandom count=1 2>/dev/null | md5sum | sed 's/^\(..\)\(..\)\(..\)\(..\).*$/\1:\2:\3:\4/')";
    echo $MACADDR
}

function pgrep            # list all processes containg $1, ps | grep
{ ps $PSOPTS | grep $1 ; }

function pkill            # kill processes containing name = $1
{
    for X in `ps aux | grep $1 | awk '{print $2}'`; do
        kill $X
        echo Killing $1 pid $X
    done
}

function phup             # send HUP to processes whos name contains $1
{
    for X in `ps $PSOPTS | grep $1 | awk '{print $2}'`; do
        kill -HUP $X
        echo Sending $1 pid $X : HangUp
    done
}

function ff               # Find a file with a pattern in name in current dir or below
{ find . -type f -iname '*'$*'*' -ls ; }

function fe               # Find a file with pattern $1 in name and Execute $2 on it
{ find . -type f -iname '*'$1'*' -exec "${2:-file}" {} \;  ; }

# Misc utilities:
function ddbench          # Test system performance with dd
{
    local WHITE="\033[1;37m"
    local NC="\033[0m"
    local grep=$(which grep)
    local file="${HOME}/.ddbench.$$"

    local space=$(df -k $HOME | tail -n1 | awk '{ print $4 }')
    if [ ${space} -lt 1100000 ]; then
        printf "Less than 1GB left on ${HOME}, cancelling test\n"
        exit 1
    fi
    #printf "Using tmp file : %s\n" "${file}"
    printf "${WHITE}Write speed ${NC}(>400MB/s is good):\n"
    dd if=/dev/zero of="${file}" bs=1M count=1024 conv=fdatasync |& ${grep} bytes
    dd if=/dev/zero of="${file}" bs=1M count=1024 conv=fdatasync |& ${grep} bytes
    dd if=/dev/zero of="${file}" bs=1M count=1024 conv=fdatasync |& ${grep} bytes
    #printf "${WHITE}Deleting buffer cache, to measure reads from disk${NC} \n"
    echo 3 | sudo tee /proc/sys/vm/drop_caches >/dev/null
    printf "${WHITE}Read speed (raw):${NC} \n"
    dd if="${file}" of=/dev/null bs=1M count=1024 |& ${grep} bytes
    printf "${WHITE}Read speed (cache):${NC} \n"
    dd if="${file}" of=/dev/null bs=1M count=1024 |& ${grep} bytes
    dd if="${file}" of=/dev/null bs=1M count=1024 |& ${grep} bytes
    dd if="${file}" of=/dev/null bs=1M count=1024 |& ${grep} bytes
    printf "${WHITE}CPU speed ${NC}(md5sum, >300MB/s): \n"
    dd if=/dev/zero bs=1M count=1024 | md5sum
    printf "${WHITE}CPU speed ${NC}(sha256sum >100-150MB/s): \n"
    dd if=/dev/zero bs=1M count=1024 | sha256sum

    #printf "Deleting test output file %s\n" "${file}"
    rm "${file}"
}

function webm2mp3         # youtube webm convert
{
    if [ -f "${1}" ]; then
        avconv -i "${1}" -vn -qscale 1 "${1%webm}mp3"
    else
        printf "Missing file: '%s'\n" "${1}"
    fi
}

function change_ext       # change_ext cfg conf
{
    for f in *.$1; do
        mv -v "$f" "${f%$1}$2"
    done
}

function myps             # list all current user's processes
{ ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }

function lsfunc           # list all functions in this file
{ grep ^function ~/configs/functions.sh | cut -c9- ; }

function calc             # Trivial command line calculator
{
    # INTEGER ONLY! --> echo The answer is: $(( $* ))
    # Floating point
    awk "BEGIN {print \"The answer is: \" $* }";
}

function apt-history      # apt-history <install|upgrade|remove|rollback>
{
    case "$1" in
        install)
            grep 'install ' /var/log/dpkg.log
            ;;
        upgrade|remove)
            grep "$1" /var/log/dpkg.log
            ;;
        rollback)
            grep upgrade /var/log/dpkg.log | \
                grep "$2" -A10000000 | \
                grep "$3" -B10000000 | \
                awk '{print $4"="$5}'
            ;;
        *)
            cat /var/log/dpkg.log
            ;;
    esac
}

function testrandomports  # test if the resolver specified in $1 uses random source ports
{ dig +short @$1 porttest.dns-oarc.net txt ; }

function genpasswd        # generate a random string of alphanums
{
    local l=$1
        [ "$l" == "" ] && l=20
        tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}

function mkrole           # Setup Ansible role "$1" dir/file structure
{
    local role=$1
    for dir in $(echo "files templates tasks handlers vars defaults meta"); do
        mkdir -p "$role/$dir"
        case "$dir" in
            tasks )
                [ ! -e "$role/$dir/main.yml" ] && echo -e "---\n# Tasks for the $role role" > "$role/$dir/main.yml"
                ;;
            handlers )
                [ ! -e "$role/$dir/main.yml" ] && echo -e "---\n# Handlers for the $role role" > "$role/$dir/main.yml"
                ;;
            vars)
                [ ! -e "$role/$dir/main.yml" ] && echo -e "---\n# Variables for the $role role" > "$role/$dir/main.yml"
                ;;
            defaults )
                [ ! -e "$role/$dir/main.yml" ] && echo -e "# http://docs.ansible.com/ansible/playbooks_roles.html#role-default-variables\n# Role default variables allow you to set default variables for included\n# or dependent roles.\n#\n# These variables will have the lowest priority of any variables available, and\n# can be easily overridden by any other variable, including inventory variables.\n---\n# Default variables for the %s role" > "$role/$dir/main.yml"
                ;;
            meta )
                [ ! -e "$role/$dir/main.yml" ] && echo -e "---\n# Role Dependancies for the $role role\n# http://docs.ansible.com/ansible/playbooks_roles.html#role-dependencies" > "$role/$dir/main.yml"
                ;;
        esac
    done
    printf "Ansible Role %s created.\n" "$role"
}

function bashtips         # Quick reference card of some useful tips and tricks
{
less <<EOF

TIPS
----
cd -            Change to the previous working directory.
Esc + .         The last command line argument of the last comment
cp snark{,.bak} Copies snark to snark.bak

^w erase word
^u erase from here to beginning of the line (I use this ALL the time.)
^a move the cursor to the beginning of the line
^e move the curor to the end of the line

DIRECTORIES
-----------
~-      Previous working directory
pushd tmp   Push tmp && cd tmp
popd        Pop && cd

GLOBBING AND OUTPUT SUBSTITUTION
--------------------------------
ls a[b-dx]e Globs abe, ace, ade, axe
ls a{c,bl}e Globs ace, able
\$(ls)      \`ls\` (but nestable!)

HISTORY MANIPULATION
--------------------
!!      Last command
!?foo       Last command containing \`foo'
^foo^bar^   Last command containing \`foo', but substitute \`bar'
!:0        Last command's command
!:^        Last command's first argument
!\$        Last command's last argument
!\$:h		Head/path of last commands last arg
!\$:t		tail/filename of last commands last arg
!:*        Last command's arguments
!:x-y      Arguments x to y of last command
C-s     search forwards in history
C-r     search backwards in history

LINE EDITING
------------
M-d     kill to end of word
C-w     kill to beginning of word
C-k     kill to end of line
C-u     kill to beginning of line
M-r     revert all modifications to current line
C-]     search forwards in line
M-C-]       search backwards in line
C-t     transpose characters
M-t     transpose words
M-u     uppercase word
M-l     lowercase word
M-c     capitalize word

COMPLETION
----------
M-/     complete filename
M-~     complete user name
M-@     complete host name
M-\$        complete variable name
M-!     complete command name
M-^     complete history

READ LINE
---------

In recent versions of bash you can specify the maximum number of characters to read:

read -p "Erase the windows partition (Y/n)? " -n1

Find

find /export ! -type d -links +1 -ls = find hard links
EOF
}

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

function debtips
{
less <<EOF
dpkg -s - show a package's description
dpkg -S - search for a pattern in packages
dpkg -l - list all packages
dpkg -L - list all files in a package

BACKUP :

dpkg --get-selections > packagelist ..then dpkg --set-selections < packagelist

use the debconf-get-selections from the debconf-utils package
to dump both the debconf database and the installer's cdebconf
database to a single file:

  $ debconf-get-selections --installer > afile
  $ debconf-get-selections >> afile

afile can now be used as a preseed file for unattended install

EOF
}

function vimtips
{
less <<EOF
SEARCH/REPLACE:
                :8,10 s/search/replace/g
                :%s/search/replace/g

Save file without permission:
                :w  !sudo tee %
ctrl-]  = jump to help/tag definition
ctrl-T  = jump back

// MY MAPPINGS :
,v      = reselect just pasted text!
:w!!    = sudo save
K       = php man
jk      = escape
ESC     = tab completion
;       = :
Insert  = toggle paste mode
F6      = spell check
F5      = nerdtree

S-J = pull next line back onto this one
Ctrl+Q  = re-hardwrap paragraphs of text
,w      = show whitespace
Ctrl+P  = phpdocblock

// Align
,a        = align = and => in php !

// nerdcomment
,c<space> - toggle line comment   !
,cc - comment current line
,cm - multiline comment a selection

// surround
Normal mode
-----------
ds  - delete a surrounding
cs  - change a surrounding
ysw - add a surrounding word      !
ysW - add a surround to WORD
yS  - add a surrounding and place the surrounded text on a new line + indent it
yss - add a surrounding to the whole line
ySS - add a surrounding to the whole line, place it on a new line + indent it
Visual mode
-----------
s   - in visual mode, add a surrounding

// marks
// yank buffers
EOF
}

function passtips
{
less <<EOF
Show existing password
zx2c4@laptop ~ $ pass Email/zx2c4.com
sup3rh4x3rizmynam3

Copy existing password to clipboard
zx2c4@laptop ~ $ pass -c Email/zx2c4.com
Copied Email/jason@zx2c4.com to clipboard. Will clear in 45 seconds.

Add password to store
zx2c4@laptop ~ $ pass insert Business/cheese-whiz-factory
Enter password for Business/cheese-whiz-factory: omg so much cheese what am
i gonna do
Add multiline password to store

zx2c4@laptop ~ $ pass insert -m Business/cheese-whiz-factory
Enter contents of Business/cheese-whiz-factory and press Ctrl+D when finished:
Hey this is my
awesome
multi
line
passworrrrrrrrd.
\^D

Generate new password
zx2c4@laptop ~ $ pass generate Email/jasondonenfeld.com 15
The generated password to Email/jasondonenfeld.com is:
somepass

Generate new alphanumeric password
zx2c4@laptop ~ $ pass -n generate Email/jasondonenfeld.com 12
The generated password to Email/jasondonenfeld.com is:
YqFsMkBeO6di

Generate new password and copy it to the clipboard
zx2c4@laptop ~ $ pass -c generate Email/jasondonenfeld.com 19
Copied Email/jasondonenfeld.com to clipboard. Will clear in 45 seconds.
EOPASS
EOF
}

function tips
{
    red='\033[01;31m';
    green='\033[01;32m';
    NC='\033[0m';
    if [[ $# -eq 0 ]]; then
        clear;
        echo -e "${red}Usage: tips TIP-NAME${NC}";
        echo -e;
        echo -e "${green}random${NC}: How to generate a random number of a certain length
${green}para${NC}: Parameter expansion
${green}hist${NC}: History
${green}var${NC}: Bash Internal Variables
${green}test${NC}: Shell tests
${green}mov${NC} : Efficient Cursor Movements" | sort;
    fi;
    case $1 in
        random)
            clear;
            echo -e "${red}To get random number from range:${NC}";
            echo -e "${green}shuf -i LOW-HIGH -n 1${NC}";
            echo -e
        ;;
        mov)
            clear;
            echo -e "${red}Moving to the beginning and end of line${NC}";
            echo -e "${green}^a${NC}: To beginning of the line (bol).";
            echo -e "${green}^e${NC}: To end of line (eol).";
            echo -e;
            echo -e "${red}Moving a character or word at a time${NC}";
            echo -e "${green}^f${NC}: Forward one character.";
            echo -e "${green}^b${NC}: Backward one character.";
            echo -e "${green}alt+f${NC}: Move cursor forward one word.";
            echo -e "${green}alt+b${NC}: Move cursor backward one word.";
            echo -e;
            echo -e "${red}Transposing letters or words${NC}";
            echo -e "${green}^t${NC}: Switches the character with the one next to it.";
            echo -e "${green}alt+t${NC}: transpose the word at the cursor location with the one preceding it.";
            echo -e;
            echo -e "${red}Changing casing${NC}";
            echo -e "${green}alt+l${NC}: Convert characters from cursor to end of the word to lowercase.";
            echo -e "${green}alt+u${NC}: Convert characters from cursor to end of the word to uppercase.";
            echo -e;
            echo -e "${red}Deleting characters or words${NC}";
            echo -e "${green}^d${NC}: Delete the character at the cursor location.";
            echo -e "${green}^k${NC}: Kill the text from the cursor location to eol.""";
            echo -e "${green}^u${NC}: Kill text from the cursor location to bol.";
            echo -e "${green}alt+d${NC}: Kill text from the cursor location to the end of the current word.";
            echo -e;
            echo -e "${red}Clearing the terminal window${NC}";
            echo -e "${green}^l${NC}: Alternative to the command ${green}clear${NC}.";
            echo -e
        ;;
        para)
            clear;
            x=abcdefghifirstjklmnopwordqrstuvwxuz0first1;
            echo -e ${green}'$x'${NC}: X: $x;
            echo -e;
            echo -e "${red}Substrings${NC}";
            echo -e ${green}'${x:12}'${NC}: First 12: ${x:12};
            echo -e ${green}'${x:15:10}'${NC}: 15 for 10: ${x:15:10};
            echo -e;
            echo -e "${red}Removals${NC}";
            echo -e ${green}'${x#*o}'${NC}: everything to o ${x#*o};
            echo -e ${green}'${x##*o}'${NC}: everything to last o ${x##*o};
            echo -e ${green}'${x%o*}'${NC}: everything from back to o ${x%o*};
            echo -e ${green}'${x%%o*}'${NC}: everything from back to last o ${x%%o*};
            echo -e;
            echo -e "${red}Replacements${NC}";
            echo -e ${green}'${x/first/this}'${NC}: replace first occurrence of word ${x/first/this};
            echo -e ${green}'${x//first/this}'${NC}: replace all occurrence of word ${x//first/this};
            echo -e ${green}'${x/first}'${NC}: if no replacement given replace once ${x/first};
            echo -e ${green}'${x//first}'${NC}: if no replacement given replace all ${x//first};
            echo -e;
            echo -e "${red}Case 1${NC}";
            echo -e ${green}'${x^}'${NC}: Uppercase first letter ${x^};
            echo -e ${green}'${x^^}'${NC}: Uppercase all letters ${x^^};
            echo -e;
            x=ABCDEFGHIFIRSTJKLMNOPWORDQRSTUVWXUZ0FIRST1;
            echo -e "${red}Case 2${NC}";
            echo -e ${green}'$x'${NC}: X: $x;
            echo -e;
            echo -e ${green}'${x,}'${NC}: Lowercase first letter ${x,};
            echo -e ${green}'${x,,}'${NC}: Lowercase all letters ${x,,};
            echo -e ${green}'${x~}'${NC}: Lowercase first letter ${x~};
            echo -e ${green}'${x~~}'${NC}: Lowercase all letters ${x~~}
        ;;
        hist)
            clear;
            echo -e "${red}History${NC}";
            echo -e "${green}!51${NC}: Recall and execute the command associated with the history number 51.";
            echo -e "${green}!-2${NC}: Recall and execute a command that we typed before our most recent one.";
            echo -e "${green}CTRL-p${NC}: Recall and execute the last command.";
            echo -e "${green}!!${NC}: Recall and execute the last command '(shortcut to ${green}!-1${NC}.)'.";
            echo -e "${green}sudo !!${NC}: Sudo the last command.";
            echo -e "${green}^foo^bar^${NC}: Replace ${green}'foo'${NC} by ${green}'bar'${NC} in the last command.";
            echo -e "${green}!!:1${NC}: Refers to the first argument of the last command.";
            echo -e "${green}!!:2-4${NC}: Refers to the 2nd to 4th argument of the last command.";
            echo -e "${green}!!:^${NC}: Refers to the first argument of the last command.";
            echo -e "${green}!!:\$${NC}: Refers to the last argument of the last command.";
            echo -e "${green}CTRL-r${NC}: Search the history forward.";
            echo -e "${green}CTRL-s${NC}: Search history backward.";
            echo -e;
            echo -e "${red}Modifiers${NC}";
            echo -e "${green}!!:$:r${NC}: Removes extension of the last argument of the last command.";
            echo -e "${green}!!:$:e${NC}: Removes all but the extension of the last argument of the last command.";
            echo -e "${green}!!:$:h${NC}: Removes the trailing pathname component, leaving the head '"/usr/local/apache" to "/usr/local"'.";
            echo -e
        ;;
        test)
            clear;
            echo -e "${red}Test if a variable is divisible by a number${NC}";
            echo -e 'if ! ((n % 4)); then';
            echo -e '    echo "$n divisible by 4."';
            echo -e 'fi';
            echo -e;
            echo -e "${red}Test the number of arguments${NC}";
            echo -e 'if [ "$#" -eq 2 ]; then';
            echo -e '    echo "The arguments are 2 as they should be"';
            echo -e 'fi';
            echo -e;
            echo -e "${red}Test the exit status${NC}";
            echo -e 'if [[ "$?" != 0 ]]; then';
            echo -e '    echo "Exit status is dofferent from 0"';
            echo -e 'fi';
            echo -e
        ;;
        var)
            clear;
            echo -e "${red}Bash Internal Variables${NC}";
            echo -e;
            echo -e ${green}'$*'${NC}": Expands all the positional parameters (Bad for parameters with space)";
            echo -e '\t'\$ 'func() { for i in $*; do echo $i; done };';
            echo -e '\t'\$ 'func hi there "hi there"';
            echo -e '\thi';
            echo -e '\tthere';
            echo -e '\thi';
            echo -e '\tthere';
            echo -e;
            echo -e ${green}'"$*"'${NC}": Expands all the positional parameters as ONE single string";
            echo -e '\t'\$ 'func() { for i in "$*"; do echo $i; done };';
            echo -e '\t'\$ 'func hi there "hi there"';
            echo -e '\thi there hi there';
            echo -e;
            echo -e ${green}'$@'${NC}": Expands all the positional parameters  (Bad for parameters with space)";
            echo -e '\t'\$ 'func() { for i in $@; do echo $i; done };';
            echo -e '\t'$ 'func hi there "hi there"';
            echo -e '\thi';
            echo -e '\tthere';
            echo -e '\thi';
            echo -e '\tthere';
            echo -e;
            echo -e ${green}'"$@"'${NC}": Expands all the positional parameters and respects space (Good for parameters with space)";
            echo -e '\t'\$ 'func() { for i in "$@"; do echo $i; done };';
            echo -e '\t'\$ 'func hi there "hi there"';
            echo -e '\thi';
            echo -e '\tthere';
            echo -e '\thi there';
            echo -e;
            echo -e ${green}'$#'${NC}": The number os positional parameters";
            echo -e;
            echo -e ${green}'$?'${NC}": Exit code of the latest command in the foreground";
            echo -e;
            echo -e ${green}'$!'${NC}": PID of the latest command in the background";
            echo -e;
            echo -e ${green}'$$'${NC}": PID of the current shell (different for scripts but same for functions)";
            echo -e;
            echo -e ${green}'$_'${NC}": Last argument of the last command";
            echo -e;
            echo -e ${green}'$-'${NC}": Bash options (see xv())";
            echo -e
        ;;
    esac
}
