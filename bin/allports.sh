#!/bin/bash
#
# nmap scan all ports in stages, written for HTB

if [ "$#" -lt 1 ] ; then                                                                                                                                                                         
	echo "[!] Error - usage: $0 <ip_address>"
	exit 1
else 
	if [ "${1:0:9}"x == "10.10.10."x ]; then
		IP="${1}"
	else
	   echo "[!] Error - ${1} doesnt look like a 10.10.10.x IP"
	   exit 1
	fi
fi 

#Scan
[[ ! -e ./.nmap-10k.nmap ]] && printf "[+]\n[+] Scanning %s : 1-10000\n[+]\n" "${IP}" && nmap -A -T4 ${IP} -p 1-10000 -oA .nmap-10k
[[ ! -e ./.nmap-20k.nmap ]] && printf "[+]\n[+] Scanning %s : 10001-20000\n[+]\n" "${IP}" && nmap -sV -sC -T4 ${IP} -p 10001-20000 -oA .nmap-20k
[[ ! -e ./.nmap-30k.nmap ]] && printf "[+]\n[+] Scanning %s : 20001-30000\n[+]\n" "${IP}" && nmap -sV -sC -T4 ${IP} -p 20001-30000 -oA .nmap-30k
[[ ! -e ./.nmap-40k.nmap ]] && printf "[+]\n[+] Scanning %s : 30001-40000\n[+]\n" "${IP}" && nmap -sV -sC -T4 ${IP} -p 30001-40000 -oA .nmap-40k
[[ ! -e ./.nmap-50k.nmap ]] && printf "[+]\n[+] Scanning %s : 40001-50000\n[+]\n" "${IP}" && nmap -sV -sC -T4 ${IP} -p 40001-50000 -oA .nmap-50k
[[ ! -e ./.nmap-60k.nmap ]] && printf "[+]\n[+] Scanning %s : 50001-60000\n[+]\n" "${IP}" && nmap -sV -sC -T4 ${IP} -p 50001-60000 -oA .nmap-60k
[[ ! -e ./.nmap-65k.nmap ]] && printf "[+]\n[+] Scanning %s : 60001-\n[+]\n" "${IP}" && nmap -sV -sC -T4 ${IP} -p 60001- -oA .nmap-65k

# Summary
[[ -f "./all.nmap" ]] && rm ./all.nmap
for FILE in .nmap-*k.nmap; do
	grep PORT ${FILE} && cat ${FILE} >> all.nmap
done

exit 0
