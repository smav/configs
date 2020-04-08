#!/bin/bash
#
# make a new centos vm
VG="mirror"
if [ ! -z "${1}" ]; then
	# Prepare info to be used
	VM=${1}
	#mac=`egrep "^$VM"'\s' ips.txt | awk '{print $3}'`; echo $mac
	MAC="52:54:$(dd if=/dev/urandom count=1 2>/dev/null | md5sum | sed 's/^\(..\)\(..\)\(..\)\(..\).*$/\1:\2:\3:\4/')"

	# CREATE DISK
	#size=`sudo lvs -o lv_size --unit=b --noheadings /dev/${VG}/centos7prep | sed 's/^ *//'`
	size=`sudo lvs -o lv_size --unit=b --noheadings /dev/mirror/centos7prep | sed 's/^ *//' | sed 's/B$//'`
	resize_offset="1277952"
	real_size=`echo "$size + $resize_offset" | bc`
	echo "{+} creating disk: size=$real_size"
	sudo lvcreate --size=${real_size}B --name=${VM} ${VG}
	echo "{+} copying filesystem.."
	sudo virt-resize /dev/${VG}/centos7prep /dev/${VG}/${VM}
	#sudo dd if=/dev/${VG}/centos7prep | pv -s 8G | sudo dd bs=512k of=/dev/${VG}/${VM}

	# COPY XML & CREATE VM
	echo "{+} dumping xml.."
	sudo virsh dumpxml centos7prep > /tmp/centos-base-vm.xml
	echo "{+} modifying xml.."
	sudo python ~/.dotfiles/bin/modify-domain.py \
		--name ${VM} \
		--new-uuid \
		--device-path=/dev/${VG}/${VM} \
		--mac-address ${MAC} \
		< /tmp/centos-base-vm.xml > /tmp/${VM}.xml
	echo "{+} creating vm: ${VM}"
	sudo virsh define /tmp/${VM}.xml
	sudo rm /tmp/centos-base-vm.xml /tmp/${VM}.xml
	#sudo virsh dumpxml ${VM}
	echo "{+} sysprepping.."
	if [ ! -z "${2}" ]; then
		IP=${2}
		# This relies on the sysprep --script parameter, script uses relative paths to refer to the VM (from the root etc/hosts) and full paths to refer to the host system
		# Create some new config from templates, we are just setting the hostname, gateway and IP for now
		sed -e "s/IP_ADDRESS_GOES_HERE/${IP}/g" -e "s/VM_NAME_GOES_HERE/${VM}/g" < ~/vms/templates/hosts > ~/vms/tmp/hosts.${VM}
		sed -e "s/IP_ADDRESS_GOES_HERE/${IP}/g" -e "s/VM_NAME_GOES_HERE/${VM}/g" < ~/vms/templates/ifcfg-eth0 > ~/vms/tmp/ifcfg-eth0.${VM}
		sed -e "s/IP_ADDRESS_GOES_HERE/${IP}/g" -e "s/VM_NAME_GOES_HERE/${VM}/g" < ~/vms/templates/network > ~/vms/tmp/network.${VM}
		sed -e "s/IP_ADDRESS_GOES_HERE/${IP}/g" -e "s/VM_NAME_GOES_HERE/${VM}/g" < ~/vms/templates/hostname > ~/vms/tmp/hostname.${VM}
		sed -e "s/IP_ADDRESS_GOES_HERE/${IP}/g" -e "s/VM_NAME_GOES_HERE/${VM}/g" < ~/vms/templates/configure.sh > ~/vms/tmp/configure.sh.${VM}
		chmod a+x ~/vms/tmp/configure.sh.${VM}
		sudo virt-sysprep -d ${VM} \
			--enable udev-persistent-net,bash-history,hostname,logfiles,utmp,script \
			--hostname ${VM} \
			--selinux-relabel \
			--script ~/vms/tmp/configure.sh.${VM}
		rm ~/vms/tmp/*.${VM}
		sudo virsh start ${VM}
	else
		sudo virt-sysprep -d ${VM} \
			--enable udev-persistent-net,bash-history,hostname,logfiles,utmp \
			--hostname ${VM} \
			--selinux-relabel
		echo "{+} No post-prep script :("
		sudo virsh start ${VM}
	fi
else
	echo "Usage: ${0} vmname ip_address"
	exit
fi

echo done
