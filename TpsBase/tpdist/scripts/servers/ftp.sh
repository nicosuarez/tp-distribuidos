#!/bin/bash

#########################################
#Script de configuracion del FTP Server #
#########################################

# El FTP server esta en la red A /25 IP 10.92.27.1

#B / 24
route add -net 10.24.3.0 netmask 255.255.255.0 gw 10.92.27.7  metric 1
#C / 30
route add -net 10.92.27.128 netmask 255.255.255.252 gw 10.92.27.7  metric 2
#D / 27
route add -net 10.24.1.0 netmask 255.255.255.224 gw 10.92.27.7  metric 3
#E / 28
route add -net 10.24.1.96 netmask 255.255.255.240 gw 10.92.27.7  metric 4
#F / 30
route add -net 10.92.27.132 netmask 255.255.255.252 gw 10.92.27.7  metric 2
#G / 25
route add -net 10.24.1.128 netmask 255.255.255.128 gw 10.92.27.7  metric 2
#H / 26
route add -net 192.168.8.64 netmask 255.255.255.192 gw 10.92.27.5  metric 2
#I / 24
route add -net 10.10.5.0 netmask 255.255.255.0 gw 10.92.27.5  metric 2
#J / 28
route add -net 10.24.1.112 netmask 255.255.255.240 gw 10.92.27.5  metric 2
#K / 29
route add -net 10.92.27.136 netmask 255.255.255.248 gw 10.92.27.5  metric 2
#L / 27
route add -net 10.24.1.32 netmask 255.255.255.224 gw 10.92.27.5  metric 1
#M / 30
route add -net 172.43.0.64 netmask 255.255.255.252 gw 10.92.27.2  metric 1
route add -net 172.43.0.68 netmask 255.255.255.252 gw 10.92.27.2  metric 1
route add -net 172.43.0.76 netmask 255.255.255.252 gw 10.92.27.2  metric 1
route add -net 172.43.0.80 netmask 255.255.255.252 gw 10.92.27.2  metric 1
route add -net 172.43.0.84 netmask 255.255.255.252 gw 10.92.27.2  metric 1
route add -net 172.43.0.88 netmask 255.255.255.252 gw 10.92.27.2  metric 1

#N / 27
route add -net 10.24.1.64 netmask 255.255.255.224 gw 10.92.27.5  metric 1
#O / 24
route add -net 133.43.1.0 netmask 255.255.255.0 gw 10.92.27.7  metric 2

#Configurar el DNS 
# DNS 1 Trelew
#echo "nameserver 10.10.5.5" > /etc/resolv.conf

# DNS Root
echo "nameserver 10.24.1.133" > /etc/resolv.conf

echo "Server FTP Configurado"

exit 0
