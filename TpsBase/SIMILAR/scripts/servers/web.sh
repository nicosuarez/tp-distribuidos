#!/bin/bash

#########################################
#Script de configuracion del Web Server #
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

#H /26
#Configura la direccion IP de la interfaz $1
#ifconfig $1:0 up 10.92.27.7 netmask 255.255.255.128
ifconfig $1 up 192.168.8.71 netmask 255.255.255.192

#Habilita IP forwarding (Aparentemente necesario para cuando hay subinterfaces)
#echo 1 > /proc/sys/net/ipv4/ip_forward

#Default
route add default gw 192.168.8.67

#Configurar el DNS 
# DNS 2 Rio Negro
echo "nameserver 10.24.3.5" > /etc/resolv.conf

echo "Server Web Configurado"

exit 0
