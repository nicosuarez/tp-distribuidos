#!/bin/bash
#################################################
#Script de configuracion de maquina con GNS3 	#
#################################################

if [ $# -ne 3 ] 
then
	echo "Debe llamar al script: ./<script>.sh [interfaz ethernet] [direccionIP] [mascara en decimal]"
	exit 1
fi

    sudo tunctl -t tap0
    sudo tunctl -t tap1
    sudo tunctl -t tap2
    sudo tunctl -t tap3
    sudo tunctl -t tap4
    sudo tunctl -t tap5
    sudo tunctl -t tap6
    sudo tunctl -t tap7
    sudo tunctl -t tap8
    sudo tunctl -t tap9

    sudo ifconfig tap0 0.0.0.0 promisc up
    sudo ifconfig tap1 0.0.0.0 promisc up
    sudo ifconfig tap2 0.0.0.0 promisc up
    sudo ifconfig tap3 0.0.0.0 promisc up
    sudo ifconfig tap4 0.0.0.0 promisc up
    sudo ifconfig tap5 0.0.0.0 promisc up
    sudo ifconfig tap6 0.0.0.0 promisc up
    sudo ifconfig tap7 0.0.0.0 promisc up
    sudo ifconfig tap8 0.0.0.0 promisc up
    sudo ifconfig tap9 0.0.0.0 promisc up
    sudo ifconfig $1 0.0.0.0 promisc up

 
    sudo brctl addbr br0

    sudo brctl addif br0 tap0
    sudo brctl addif br0 $1
    sudo brctl addif br0 tap1
    sudo brctl addif br0 tap2
    sudo brctl addif br0 tap3
    sudo brctl addif br0 tap4
    sudo brctl addif br0 tap5
    sudo brctl addif br0 tap6
    sudo brctl addif br0 tap7
    sudo brctl addif br0 tap8
    sudo brctl addif br0 tap9



    sudo ifconfig br0 up
    sudo ifconfig br0 $2/$3 
    sudo ifconfig tap0 10.92.27.6/25 #HostC 
    sudo ifconfig tap1 10.24.1.4/27 #HostA 
    sudo ifconfig tap2 10.10.5.6/24 #HostB
    sudo ifconfig tap3 10.24.1.133/25 #DNS Root
    sudo ifconfig tap4 10.10.5.5/24 #DNS1
    sudo ifconfig tap5 10.24.3.5/24 #DNS2
    sudo ifconfig tap6 10.92.27.1/25 #FTP
    sudo ifconfig tap7 192.168.8.71/26 #Webserver
    sudo ifconfig tap8 10.24.1.129/25 #Telnet red Guido
    sudo ifconfig tap9 10.24.1.65/27 #Telnet red Nestor
	

#    sudo route add default gw 10.10.10.254


