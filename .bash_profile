##############################################################################
#
# Bash Profile - only read on login session
#
##############################################################################

# Load user .bashrc, failing that try the system config
for file in  ~/.bashrc /etc/bash.bashrc /etc/bashrc; do
    [ -r "$file" ] && source $file && break  # Use the first one found
done
