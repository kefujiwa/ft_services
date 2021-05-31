#!/bin/bash

BOLD="\x1b[1m"
GREY="\x1b[30m"
RED="\x1b[31m"
GREEN="\x1b[32m"
YELLOW="\x1b[33m"
BLUE="\x1b[34m"
PURPLE="\x1b[35m"
CYAN="\x1b[36m"
WHITE="\x1b[37m"
RESET="\x1b[0m"

SERVICES=(
	"ftps"
	"grafana"
	"influxdb"
	"mysql"
	"nginx"
	"phpmyadmin"
	"wordpress"
)

init () {
	minikube stop
	minikube delete
	minikube start --driver=docker --cpus=2
	minikube dashboard &
	eval $(minikube docker-env)
	kubectl apply -f srcs/secret/secret.yml
}

build_images () {
	printf "${BLUE}Building images...\n${RESET}"
	for e in ${SERVICES[@]}; do
		printf "${BLUE}Building ${e}...\n${RESET}"
		docker build -t kefujiwa/${e} -q ./srcs/${e}/
	done
}

setup_metallb () {
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml
	kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
	kubectl apply -f srcs/metallb/metallb-config.yml
}

setup_services () {
	printf "${BLUE}Creating services...\n${RESET}"
	for e in ${SERVICES[@]}; do
		kubectl apply -f ./srcs/${e}/${e}.yml
	done
}

welcome () {
	printf ${BOLD}${BLUE}
	echo 'Welcome to...'
	echo ''
	echo ' _|_|_|_|  _|_|_|_|_|  '
	echo ' _|            _|      '
	echo ' _|_|_|        _|      '
	echo ' _|            _|      '
	echo ' _|            _|      '
	echo ''
	echo '   _|_|_|                                  _|                              '
	echo ' _|          _|_|    _|  _|_|  _|      _|        _|_|_|    _|_|      _|_|_|'
	echo '   _|_|    _|_|_|_|  _|_|      _|      _|  _|  _|        _|_|_|_|  _|_|    '
	echo '       _|  _|        _|          _|  _|    _|  _|        _|            _|_|'
	echo ' _|_|_|      _|_|_|  _|            _|      _|    _|_|_|    _|_|_|  _|_|_|  '
	echo ''
	echo 'Open http://192.168.49.100:80 on your browser\n'
	printf ${RESET}
}

init
build_images
setup_metallb
setup_services
welcome
