# ft_services
ft_services is a project to setup a Kubernetes cluster. It consists an Nginx, an FTPS, a Wordpress and a PHPMyAdmin working with a MySQL database, and a Grafana linked to an InfluxDB database for monitoring.

## Getting Started
This project is meant to run in the 42 xubuntu VM. Running it anywhere else would cause problems, due to the VM configuration. If you want to run it anywhere else, make sure to install the requirements (minikube, kubectl, docker...) yourself.

Run:
```Bash
bash setup.sh
```

### Basic introduction
Use the following command to restart Minikube.
```Bash
minikube stop
minikube delete
minikube start
minikube dashboard
```
Use the following command to check all kubernetes components.
```Bash
kubectl get all
```
Use the following command to access pods.
```Bash
kubectl exec -it "pod-name-here" -- /bin/sh
```
For details about kubernetes, go to [kefujiwa's Notion Page](https://www.notion.so/Kubernetes-8427c9be0e57405ba30868848e27992d).

## How to access Nginx
Nginx HTTP server listens for incoming connection and binds on port 80.
It is a systematic redirection of type 301 to port 443.

Open http://192.168.49.100:80 on your browser.

Nginx HTTPS server listens for secure connections on port 443.

Open https://192.168.49.100:443 on your browser.

The Nginx server will allow access to '/phpmyadmin' and '/wordpress'.

```Bash
# This is a reverse proxy to IP:PMAPORT(https://192.168.49.100:5000).
https://192.168.49.100/phpmyadmin

# This will make a redirect 307 to IP:WPPORT(https://192.168.49.100:5050).
https://192.168.49.100/wordpress

# Use the following command to check redirect 307.
curl -I -k https://192.168.49.100/wordpress
```

SSHD is listening on port 22.
Use the following command to connect Nginx server using SSH.
```Bash
ssh sshuser@192.168.49.100 -p 22
password: sshpass
```

## How to access WordPress

The WordPress website have its own nginx server and it is listening on port 5050.
It works with a MySQL Database that is listening on port 3306.

Open https://192.168.49.100:5050 on your browser.

The following information is the users and an administrator of the WordPress website.
| USER_LOGIN | USER_PASS |
|:-----------|:------------ |
| admin | admin |
| nobody | nobody |
| somebody | somebody |

Open https://192.168.49.100:5050/wp-admin on your browser and check if you can login with the user account above.

## How to access phpmyadmin

phpMyAdmin have its own nginx server and it is listening on port 5050.
It is linked with the MySQL database listening on port 3306.

Open https://192.168.49.100:5000 on your browser.

The following information is the login info.
| USERNAME | PASSWORD |
|:-----------|:------------ |
| user | password |

## How to access FTPS

FTPS server is listening on port 21.
Following command is an example of ftps usage.

```
lftp -e "set ssl:verify-certificate false" -u ftpsuser,ftpspass 192.168.49.100 -p 21

get "file_name"
ls

mv "file_name" "whatever name"
put "whatever name"
!ls
```

## How to access Grafana

Grafana platform is listening on port 3000 and it is monitoring all the containers.
It is linked with an InfluxDB database listening on port 8086.

Open https://192.168.49.100:3000 on your browser.

Dashboards to analyze CPU and Memory Resources of each Pods are provided.

The following information is the login info.
| USERNAME | PASSWORD |
|:-----------|:------------ |
| admin | admin |

If you want to stop influxDB and check if the data persists, use the following command.

```Bash
# InfluxDB container will restart, due to liveness-Probe.
kubectl exec deploy/influxdb-deployment -- pkill influxd
```
