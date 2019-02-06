##############################################################################
#
# Bash Profile - only read on login session
#
##############################################################################

# Load user .bashrc, failing that try the system config
for file in  ~/.bashrc /etc/bash.bashrc /etc/bashrc; do
    [ -r "$file" ] && source $file && break  # Use the first one found
done

# Keychain disabled there is ssh-agent code in .bashrc
#
## Use keychain (http://www.gentoo.org/proj/en/keychain/) to manage ssh-agent
#KEYCHAIN="/usr/bin/keychain"
#if [ -x ${KEYCHAIN} ]; then
#    # Let  re-use ssh-agent and/or gpg-agent between logins
#    # Load default id_rsa and/or id_dsa keys, add others here as needed
#    # See also --clear --ignore-missing --noask --quiet --time-out
#    eval `/usr/bin/keychain --eval --agents ssh --nogui -Q -q id_rsa`
#
#    # Old way
#    #/usr/bin/keychain -Q -q --nogui ~/.ssh/id_rsa
#    ## Source the agent details
#	#HOSTNAME=`hostname -s`
#    #. $HOME/.keychain/${HOSTNAME}-sh
#fi

# Mouse key swap disabled for now
#
# If in X, swap the middle and right mouse buttons (windows/putty mode)
# needed to stop me messing up jumpbox pasting on windows.
#if [[ ${DISPLAY} == ":0.0" ]]; then
#	if [ -x /usr/bin/xmodmap ]; then
#		xmodmap -e "pointer = 1 3 2" 2>&1
#	fi
#fi
# see .Xmodmap

# On login create a tmux session which we work from
case $- in
    *i*) # interactive shell
		# Work from Main tmux session, or create one
        case ${HOSTNAME} in
            lupus)
                ~/configs/bin/tmux_login.sh
                ;;
        esac
    ;;
esac
