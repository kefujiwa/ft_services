#!/bin/sh

adduser -h /var/www -D sshuser && echo "sshuser:sshpass" | chpasswd

telegraf &

/usr/sbin/sshd

nginx -g 'daemon off;'
