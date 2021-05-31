# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: kefujiwa <kefujiwa@student.42tokyo.jp>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/05/16 13:26:03 by kefujiwa          #+#    #+#              #
#    Updated: 2021/05/31 15:24:54 by kefujiwa         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# set the base image from alpine:3.13
FROM	alpine:3.13

# set maintainer and version information
LABEL	maintainer="Kenshi Fujiwara <kefujiwa@student.42tokyo.jp>"
LABEL	version="1.0"
LABEL	description="ftps server"

# install necessary tools
RUN	apk update && \
	apk add --no-cache vsftpd openssl telegraf

# generate secret key > create csr > create digital certificate
RUN	mkdir -p /etc/vsftpd/ssl && \
	openssl genrsa -out /etc/vsftpd/ssl/server.key 2048 && \
	openssl req -new \
				-key /etc/vsftpd/ssl/server.key \
				-subj "/C=JP/ST=Tokyo/L=Minato/O=42/OU=42Tokyo/CN=localhost" \
				-out /etc/vsftpd/ssl/server.csr && \
	openssl x509 -in /etc/vsftpd/ssl/server.csr \
				 -days 365 \
				 -req -signkey /etc/vsftpd/ssl/server.key \
				 -out /etc/vsftpd/ssl/server.crt

# copy srcs to tmp directory
COPY	./srcs	/tmp

# move configuration files to the specific directory
RUN	mkdir -p /etc/telegraf && \
	mv /tmp/telegraf.conf /etc/telegraf/ && \
	mv /tmp/vsftpd.conf /etc/vsftpd/ && \
	chmod +x /tmp/init.sh

EXPOSE	20 21 30020 30021

ENTRYPOINT	[ "/tmp/init.sh" ]
