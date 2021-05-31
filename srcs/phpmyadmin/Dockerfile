# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: kefujiwa <kefujiwa@student.42tokyo.jp>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/05/18 14:27:31 by kefujiwa          #+#    #+#              #
#    Updated: 2021/06/01 01:36:26 by kefujiwa         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# set the base image from alpine:3.13
FROM	alpine:3.13

# set maintainer and version information
LABEL	maintainer="Kenshi Fujiwara <kefujiwa@student.42tokyo.jp>"
LABEL	version="1.0"
LABEL	description="phpmyadmin server"

# install necessary tools
RUN	apk update && \
	apk add --no-cache	nginx \
						openssl \
						php7 \
						php7-cgi \
						php7-common \
						php7-ctype \
						php7-curl \
						php7-dom \
						php7-fpm \
						php7-gd \
						php7-gettext \
						php7-iconv \
						php7-imap \
						php7-json \
						php7-ldap \
						php7-mbstring \
						php7-mcrypt \
						php7-mysqli \
						php7-pdo \
						php7-pdo_mysql \
						php7-phar \
						php7-posix \
						php7-session \
						php7-soap \
						php7-xml \
						php7-xmlrpc \
						telegraf

# copy srcs to tmp directory
COPY	./srcs	/tmp

# wget phpmyadmin
RUN	mkdir -p /var/www/phpmyadmin && \
	wget -O /tmp/phpmyadmin.tar.gz --no-check-certificate https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz && \
	tar -xvzf /tmp/phpmyadmin.tar.gz -C /var/www/phpmyadmin --strip-components 1 && \
	rm /tmp/phpmyadmin.tar.gz && \
	chown -R nginx:nginx /var/www/phpmyadmin;

# generate secret key > create csr > create digital certificate
RUN	mkdir -p /etc/nginx/ssl && \
	openssl genrsa -out /etc/nginx/ssl/server.key 2048 && \
	openssl req -new \
				-key /etc/nginx/ssl/server.key \
				-subj "/C=JP/ST=Tokyo/L=Minato/O=42/OU=42Tokyo/CN=localhost" \
				-out /etc/nginx/ssl/server.csr && \
	openssl x509 -in /etc/nginx/ssl/server.csr \
				 -days 365 \
				 -req -signkey /etc/nginx/ssl/server.key \
				 -out /etc/nginx/ssl/server.crt

# create a directory to store nginx.pid -- https://github.com/gliderlabs/docker-alpine/issues/185
RUN mkdir -p /run/nginx && \
	mkdir -p /run/php-fpm

# move configuration files to the specific directory
RUN	mkdir -p /etc/telegraf && \
	mv /tmp/telegraf.conf /etc/telegraf/ && \
	mv /tmp/default.conf /etc/nginx/conf.d/default.conf && \
	chmod +x /tmp/init.sh

EXPOSE	5000

ENTRYPOINT	[ "/tmp/init.sh" ]
