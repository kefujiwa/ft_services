#!/bin/sh

telegraf &

/usr/share/grafana/bin/grafana-server --homepath=/usr/share/grafana
