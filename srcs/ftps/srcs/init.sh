#!/bin/sh

adduser -h /var/lib/ftp -D $FTPS_USER && echo "$FTPS_USER:$FTPS_PASSWORD" | chpasswd

telegraf &

vsftpd /etc/vsftpd/vsftpd.conf
