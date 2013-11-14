#!/bin/bash

#########################################
# Configuracion de Ruteo para DNS Root  #
#########################################

#El DNS Root pertenece a la red G
#G /25 IP 10.24.1.133

#Tabla de Ruteo

#A / 25 
route add -net 10.92.27.0 netmask 255.255.255.128 gw 10.24.1.131  metric 2
#B / 24
route add -net 10.24.3.0 netmask 255.255.255.0 gw 10.24.1.131  metric 2
#C / 30
route add -net 10.92.27.128 netmask 255.255.255.252 gw 10.24.1.131  metric 1
#D / 27
route add -net 10.24.1.0 netmask 255.255.255.224 gw 10.24.1.131  metric 1
#E / 28
route add -net 10.24.1.96 netmask 255.255.255.240 gw 10.24.1.130  metric 1
#F / 30
route add -net 10.92.27.132 netmask 255.255.255.252 gw 10.24.1.132  metric 1
#H / 26
route add -net 192.168.8.64 netmask 255.255.255.192 gw 10.24.1.132  metric 3
#I / 24
route add -net 10.10.5.0 netmask 255.255.255.0 gw 10.24.1.132  metric 2
#J / 28
route add -net 10.24.1.112 netmask 255.255.255.240 gw 10.24.1.132  metric 3
#K / 29
route add -net 10.92.27.136 netmask 255.255.255.248 gw 10.24.1.132  metric 3
#L / 27
route add -net 10.24.1.32 netmask 255.255.255.224 gw 10.24.1.132  metric 2
#M / 30
route add -net 172.43.0.64 netmask 255.255.255.252 gw 10.24.1.132  metric 1
route add -net 172.43.0.68 netmask 255.255.255.252 gw 10.24.1.132  metric 1
route add -net 172.43.0.76 netmask 255.255.255.252 gw 10.24.1.132  metric 1
route add -net 172.43.0.80 netmask 255.255.255.252 gw 10.24.1.132  metric 1
route add -net 172.43.0.84 netmask 255.255.255.252 gw 10.24.1.132  metric 1
route add -net 172.43.0.88 netmask 255.255.255.252 gw 10.24.1.132  metric 1

#O / 24
route add -net 133.43.1.0 netmask 255.255.255.0 gw 10.24.1.131  metric 2

#Configurar el DNS 
# DNS 2 Rio Negro
#echo "nameserver 10.24.3.5" > /etc/resolv.conf

# DNS Root
#echo "nameserver 10.24.1.133" > /etc/resolv.conf

echo "DNS1 Configurado"

exit 0
