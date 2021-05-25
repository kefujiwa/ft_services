# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: kefujiwa <kefujiwa@student.42tokyo.jp>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/05/18 14:28:41 by kefujiwa          #+#    #+#              #
#    Updated: 2021/05/23 23:57:48 by kefujiwa         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# set the base image from alpine:3.13
FROM	alpine:3.13

# set maintainer and version information
LABEL	maintainer="Kenshi Fujiwara <kefujiwa@student.42tokyo.jp>"
LABEL	version="1.0"
LABEL	description="web server (nginx)"

# install necessary tools
RUN	apk update && \
	apk add --no-cache nginx openssh openssl telegraf

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

# configure ssh connection
RUN	ssh-keygen -q -t rsa -N '' -f /etc/ssh/ssh_host_rsa_key

# create a directory to store nginx.pid -- https://github.com/gliderlabs/docker-alpine/issues/185
RUN mkdir -p /run/nginx

# copy srcs to tmp directory
COPY	./srcs/*	/tmp/

# move configuration files to the specific directory
RUN	mkdir -p /etc/telegraf && \
	mv /tmp/telegraf.conf /etc/telegraf/ && \
	mv /tmp/default.conf /etc/nginx/conf.d/default.conf && \
	chmod +x /tmp/init.sh

EXPOSE	22 80 443

ENTRYPOINT	[ "/tmp/init.sh" ]
