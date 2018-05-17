#!/bin/bash

LOGFILE="/var/log/rsync-fs_export.log"
DATE=`date`

echo >> ${LOGFILE}
echo "##################################################" >> ${LOGFILE}
echo "# Rsync started @ ${DATE}" >> ${LOGFILE}
echo "##################################################" >> ${LOGFILE}

# unmount the crypt partition
#/bin/umount /export/home/user >> ${LOGFILE} 2>&1 && /sbin/cryptsetup luksClose crypt_user >> ${LOGFILE} 2>&1

/usr/bin/rsync -av --delete-before /export /backup >> ${LOGFILE} 2>&1

echo >> ${LOGFILE}
