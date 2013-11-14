#!/bin/bash

#########################################
#Script de configuracion del Host A     #
#########################################

if [ $# -ne 1 ];
then
	echo "Debe llamar al script: ./<script>.sh ethX"
	exit 1
fi

#Baja el servicio network-manager 
/etc/init.d/network-manager stop 

#Hace flush de las tablas que contienen los ips
iptables -F

#Borrar todas las direcciones de ip asignada a la interfaz $1
ip addr flush dev $1

#B /24
#Configura la direccion IP de la interfaz $1
#ifconfig $1:0 up 10.92.27.7 netmask 255.255.255.128
ifconfig $1 up 10.24.1.4 netmask 255.255.255.224

#Habilita IP forwarding (Aparentemente necesario para cuando hay subinterfaces)
#echo 1 > /proc/sys/net/ipv4/ip_forward

#A / 25
route add -net 10.92.27.0 netmask 255.255.255.128 gw 10.24.1.2  metric 2
#B / 24
route add -net 10.24.3.0 netmask 255.255.255.0 gw 10.24.1.2  metric 3
#C / 30
route add -net 10.92.27.128 netmask 255.255.255.252 gw 10.24.1.2  metric 1
#E / 28
route add -net 10.24.1.96 netmask 255.255.255.240 gw 10.24.1.1  metric 1
#F / 30
route add -net 10.92.27.132 netmask 255.255.255.252 gw 10.24.1.2  metric 2
#G / 25
route add -net 10.24.1.128 netmask 255.255.255.128 gw 10.24.1.2  metric 1
#H / 26
route add -net 192.168.8.64 netmask 255.255.255.192 gw 10.24.1.3  metric 3
#I / 24
route add -net 10.10.5.0 netmask 255.255.255.0 gw 10.24.1.3  metric 2
#J / 28
route add -net 10.24.1.112 netmask 255.255.255.240 gw 10.24.1.3  metric 4
#K / 29
route add -net 10.92.27.136 netmask 255.255.255.248 gw 10.24.1.3  metric 5
#L / 27
route add -net 10.24.1.32 netmask 255.255.255.224 gw 10.24.1.3  metric 5
#M / 30
route add -net 172.43.0.64 netmask 255.255.255.252 gw 10.24.1.2  metric 3
route add -net 172.43.0.68 netmask 255.255.255.252 gw 10.24.1.2  metric 3
route add -net 172.43.0.76 netmask 255.255.255.252 gw 10.24.1.2  metric 3
route add -net 172.43.0.80 netmask 255.255.255.252 gw 10.24.1.2  metric 3
route add -net 172.43.0.84 netmask 255.255.255.252 gw 10.24.1.2  metric 3

#N / 27
route add -net 10.24.1.64 netmask 255.255.255.224 gw 10.24.1.2  metric 2
#O / 24
route add -net 133.43.1.0 netmask 255.255.255.0 gw 10.24.1.3  metric 2

#Default
route add default gw 10.24.1.2

#Configurar el DNS 
# DNS 2 Punta Indio
echo "nameserver 10.24.3.5" > /etc/resolv.conf

echo "Host A Configurado"

exit 0
