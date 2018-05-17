#!/bin/bash
#
# Compare current IP with domain IP, if it has changed email an alert

# Setup
EMAIL_ADDRESS="root"
IP_DOMAIN=$(dig +short ntropy.net @208.67.222.222)
# This check could be replaced by a lookup on our DNS servers
IPCHECK_URL="icanhazip.com"
IP_CURRENT=$(/usr/bin/curl -s ${IPCHECK_URL})
# Flag is to stop email spamming
FLAG="/tmp/ip_flag"

# main
if [[ ${IP_DOMAIN} != ${IP_CURRENT} ]]; then
	# IP is different from expected
	if [ ! -e ${FLAG} ]; then
		# IPs different but no flag set, create one to stop email spam
		touch ${FLAG}
		echo "IP Changed to ${IP_CURRENT} FROM ${IP_DOMAIN}" | /usr/bin/mail -s "IP CHANGED to ${IP_CURRENT}" ${EMAIL_ADDRESS}
	fi
	exit 0
else
	# IPs are the same
	if [ -e ${FLAG} ]; then
		# IPs are the same so we tidy up the flag
		rm ${FLAG}
	fi
	exit 0
fi

# future improvements:
# Add an array of sites and rand pick which site to check.
# Add IP checking function to confirm valid IPs.
# both ideas from :
# http://unix.stackexchange.com/questions/22615/how-can-i-get-my-external-ip-address-in-bash
