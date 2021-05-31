# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: kefujiwa <kefujiwa@student.42tokyo.jp>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/05/18 14:29:48 by kefujiwa          #+#    #+#              #
#    Updated: 2021/05/31 15:25:18 by kefujiwa         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# set the base image from alpine:3.13
FROM	alpine:3.13

# set maintainer and version information
LABEL	maintainer="Kenshi Fujiwara <kefujiwa@student.42tokyo.jp>"
LABEL	version="1.0"
LABEL	description="influxDB server"

# install necessary tools
RUN	apk update && \
	apk add --no-cache influxdb telegraf

# copy srcs to tmp directory
COPY	./srcs	/tmp

# move configuration files to the specific directory
RUN	mkdir -p /etc/telegraf && \
	mv /tmp/telegraf.conf /etc/telegraf/ && \
	chmod +x /tmp/init.sh

EXPOSE	8086

ENTRYPOINT	[ "/tmp/init.sh" ]
