#!/bin/bash

#################################################
#Script de desconfiguracion de maquina con GNS3 #
#################################################

if [ $# -ne 3 ] 
then
	echo "Debe llamar al script: ./<script>.sh [interfaz ethernet] [direccionIP] [mascara]"
	exit 1
fi


sudo ifconfig br0 down


sudo brctl delif br0 $1
sudo brctl delif br0 tap0
sudo brctl delif br0 tap1
sudo brctl delif br0 tap2
sudo brctl delif br0 tap3
sudo brctl delif br0 tap4
sudo brctl delif br0 tap5
sudo brctl delif br0 tap6
sudo brctl delif br0 tap7
sudo brctl delif br0 tap8
sudo brctl delif br0 tap9


sudo brctl delbr br0

sudo tunctl -d tap0
sudo tunctl -d tap1
sudo tunctl -d tap2
sudo tunctl -d tap3
sudo tunctl -d tap4
sudo tunctl -d tap5
sudo tunctl -d tap6
sudo tunctl -d tap7
sudo tunctl -d tap8
sudo tunctl -d tap9

sudo ifconfig $1 up
sudo ifconfig $1 $2 netmask $3

