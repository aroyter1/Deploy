#!/bin/sh
# Генерируем hosts-файл для dnsmasq
/usr/local/bin/generate-hosts.sh
# Запускаем dnsmasq
exec dnsmasq --no-daemon