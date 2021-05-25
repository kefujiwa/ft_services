# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: kefujiwa <kefujiwa@student.42tokyo.jp>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/05/18 14:26:56 by kefujiwa          #+#    #+#              #
#    Updated: 2021/05/24 01:17:50 by kefujiwa         ###   ########.fr        #
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
	apk add --no-cache mariadb telegraf

# turn off skip-networking
RUN	sed -i -e s/skip-networking/'#skip-networking'/ /etc/my.cnf.d/mariadb-server.cnf

# copy srcs to tmp directory
COPY	./srcs/*	/tmp/

# move configuration files to the specific directory
RUN	mkdir -p /etc/telegraf && \
	mv /tmp/telegraf.conf /etc/telegraf/ && \
	chmod +x /tmp/init.sh

EXPOSE	3306

ENTRYPOINT	[ "/tmp/init.sh" ]
