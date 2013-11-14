#!/bin/bash

#########################################
#Script de configuracion del Web Server #
#########################################

# El Webserver esta en la red H / 26 IP 192.168.8.71

#A / 25 
route add -net 10.92.27.0 netmask 255.255.255.128 gw 192.168.8.67  metric 2
#B / 24
route add -net 10.24.3.0 netmask 255.255.255.0 gw 192.168.8.67  metric 2
#C / 30
route add -net 10.92.27.128 netmask 255.255.255.252 gw 192.168.8.67  metric 1
#D / 27
route add -net 10.24.1.0 netmask 255.255.255.224 gw 192.168.8.67  metric 1
#E / 28
route add -net 10.24.1.96 netmask 255.255.255.240 gw 192.168.8.67  metric 1
#F / 30
route add -net 10.92.27.132 netmask 255.255.255.252 gw 192.168.8.67  metric 1
#G / 25
route add -net 10.24.1.128 netmask 255.255.255.128 gw 192.168.8.67  metric 2
#I / 24
route add -net 10.10.5.0 netmask 255.255.255.0 gw 192.168.8.67  metric 2
#J / 28
route add -net 10.24.1.112 netmask 255.255.255.240 gw 192.168.8.67  metric 3
#K / 29
route add -net 10.92.27.136 netmask 255.255.255.248 gw 192.168.8.67  metric 3
#L / 27
route add -net 10.24.1.32 netmask 255.255.255.224 gw 192.168.8.67  metric 2
#M / 30
route add -net 172.43.0.64 netmask 255.255.255.252 gw 192.168.8.67  metric 1
route add -net 172.43.0.68 netmask 255.255.255.252 gw 192.168.8.67  metric 1
route add -net 172.43.0.76 netmask 255.255.255.252 gw 192.168.8.67  metric 1
route add -net 172.43.0.80 netmask 255.255.255.252 gw 192.168.8.67  metric 1
route add -net 172.43.0.84 netmask 255.255.255.252 gw 192.168.8.67  metric 1
route add -net 172.43.0.88 netmask 255.255.255.252 gw 192.168.8.67  metric 1

#N / 27
route add -net 10.24.1.64 netmask 255.255.255.224 gw 192.168.8.67  metric 1
#O / 24
route add -net 133.43.1.0 netmask 255.255.255.0 gw 192.168.8.67  metric 2

#Configurar el DNS 
# DNS 2 Rio Negro
#echo "nameserver 10.24.3.5" > /etc/resolv.conf

# DNS Root
echo "nameserver 10.24.1.133" > /etc/resolv.conf

echo "Server Web Configurado"

exit 0
