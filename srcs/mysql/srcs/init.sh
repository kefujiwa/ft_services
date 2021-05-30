#!/bin/sh

if [ ! -d /var/lib/mysql/$MYSQL_DATABASE ]; then
# initialize MariaDB
	mysql_install_db --user=mysql --datadir=/var/lib/mysql --auth-root-authentication-method=normal
	cat << EOF > init.sql
USE mysql;
FLUSH PRIVILEGES ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
CREATE DATABASE ${MYSQL_DATABASE} CHARACTER SET utf8;
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' ;
GRANT ALL ON ${MYSQL_DATABASE}.* TO ${MYSQL_USER}@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' ;
FLUSH PRIVILEGES ;
EOF
	/usr/bin/mysqld --user=mysql --bootstrap < init.sql
	rm -f init.sql
fi

chown -R mysql:mysql /var/lib/mysql/

telegraf &

/usr/bin/mysqld_safe \
	--user=mysql \
	--datadir=/var/lib/mysql \
	--plugin-dir=/usr/lib/mariadb/plugin \
	--pid-file=/run/mysqld/mariadb.pid \
	--port=3306 \
	--skip-networking=0

tail -f /var/lib/mysql/mysql-*.err
