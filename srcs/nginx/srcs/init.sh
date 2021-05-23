#!/bin/sh

telegraf &

/usr/sbin/sshd

nginx -g 'deamon off;'
