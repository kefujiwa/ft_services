# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: kefujiwa <kefujiwa@student.42tokyo.jp>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/05/18 14:24:32 by kefujiwa          #+#    #+#              #
#    Updated: 2021/05/25 17:49:41 by kefujiwa         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# set the base image from alpine:3.13
FROM	alpine:3.13

# set maintainer and version information
LABEL	maintainer="Kenshi Fujiwara <kefujiwa@student.42tokyo.jp>"
LABEL	version="1.0"
LABEL	description="grafana server"

# install necessary tools
RUN	apk update && \
	apk add --no-cache openssl libc6-compat telegraf

# wget grafana
ENV	GRAFANA_VERSION=7.4.5
RUN	mkdir -p /usr/share/grafana && \
	wget -O /tmp/grafana.tar.gz --no-check-certificate https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz && \
	tar -xvzf /tmp/grafana.tar.gz -C /usr/share/grafana --strip-components 1 && \
	rm /tmp/grafana.tar.gz

# generate secret key > create csr > create digital certificate
RUN	mkdir -p /etc/grafana/ssl && \
	openssl genrsa -out /etc/grafana/ssl/grafana.key 2048 && \
	openssl req -new \
				-key /etc/grafana/ssl/grafana.key \
				-subj "/C=JP/ST=Tokyo/L=Minato/O=42/OU=42Tokyo/CN=localhost" \
				-out /etc/grafana/ssl/grafana.csr && \
	openssl x509 -in /etc/grafana/ssl/grafana.csr \
				 -days 365 \
				 -req -signkey /etc/grafana/ssl/grafana.key \
				 -out /etc/grafana/ssl/grafana.crt

# set environtment variable
ENV	GF_SECURITY_ADMIN_USER: admin \
	GF_SECURITY_ADMIN_PASSWORD: password \
	GF_USERS_ALLOW_SIGN_UP: "false" \
	GF_USERS_ALLOW_ORG_CREATE: "false"

# copy srcs to tmp directory
COPY	./srcs/*	/tmp/

# move configuration files to the specific directory
RUN	mkdir -p /etc/telegraf && \
	mv /tmp/telegraf.conf /etc/telegraf/ && \
	mv /tmp/custom.ini /usr/share/grafana/conf/ && \
	chmod +x /tmp/init.sh

WORKDIR	/usr/share/grafana

EXPOSE	3000

ENTRYPOINT	[ "/tmp/init.sh" ]
