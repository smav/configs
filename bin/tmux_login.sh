#!/bin/bash
#
# Tmux wrapper to launch my main tmux session(on login typically)
# or create it if it doesnt exist.

# Sanity checks
case $TERM in
    # tmux/screen profiles set term to screen-256color
    # do not run if in a screen/tmux session
    screen*)
        #echo "TERM is set to screen already"
        exit 1
        ;;
    *)
        ;;
esac

# TERM test above may be flawed.. test for non-empty TMUX var in env
if [[ -n "$TMUX" ]]; then
    #echo "TMUX environmental variable set, exiting $0"
    exit 1
fi
#/Sanity Checks

# Check if the main session is running, attach if so, create and attach if not
SESSION="main"
WIN1_NAME="logs"

/usr/bin/tmux has-session -t ${SESSION}
if [[ $? -eq 0 ]]; then
    #echo "Attaching to ${SESSION}..."
    /usr/bin/tmux -2 -u attach-session -t ${SESSION} #\; display "Attaching.."
else
    #echo "Creating  ${SESSION}..."
    case ${HOSTNAME} in
        lupus)
        /usr/bin/tmux -2 -u new-session -d -n ${WIN1_NAME} -s ${SESSION} '/usr/bin/sudo /usr/bin/tail -F /var/log/syslog | /usr/bin/ccze' \; \
         split-window -d -t "${SESSION}:${WIN1_NAME}" '/usr/bin/sudo /usr/sbin/iftop -nNB -i eth1'\; \
         new-window -t ${SESSION} \; attach
        ;;
    esac
fi
#         split-window -d -t "${SESSION}:${WIN1_NAME}" 'virt-top -c qemu:///system'\; \
