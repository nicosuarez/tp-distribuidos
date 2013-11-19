#!/bin/bash

function help {

  echo ""
 
  echo "###################################################"

  echo "Script para iniciar los serividores DNS"

  echo "###################################################"

  echo ""
  
  echo "	-Para iniciar el DNSRoot, ejecutar el script con el parámetro \"dnsroot\" "

  echo ""
  
  echo "	-Para iniciar el DNS1, ejecutar el script con el parámetro \"dns1\" "

  echo ""

  echo "	-Para iniciar el DNS2, ejecutar el script con el parámetro \"dns2\" "

  echo ""
  
}

function instalarBind {
	echo "Verificando que bind9 este instalado..."
	installed=`dpkg -s bind9 | grep 'ok installed'`
	if [ "$installed" == "" ]; then
		echo "bind9 no esta instalado!"
		sudo apt-get install bind9
	else
		echo "bind9 esta instalado!"
	fi  
}

function iniciarDeamonBind {
  echo "Iniciando el deamon bind9"
  sudo service bind9 restart  
}

function dns1 {

  dir=$(dirname $(which $0))

  sudo ifconfig eth0 192.168.8.4 netmask 255.255.255.0 up

  sudo route add -net 0.0.0.0 netmask 0.0.0.0 gw 192.168.8.1 metric 1
  
  instalarBind

  echo "###################################################"

  echo "Copiando archivos necesarios para levantar el deamon bind9"

  echo "###################################################"

  chmod -R 777 /etc/bind
  sudo cp -R $dir/../../dns/secundario1/* /etc/bind/
  sudo chattr -i /etc/resolv.conf
  sudo chmod 777 /etc/resolv.conf
  echo "Agregando la direccion IP de DNS1 al archivo /etc/resolv.conf..."
  echo "search riocolorado.chubut.dc.fi.uba.ar" >> /etc/resolv.conf 
  echo "nameserver 192.168.8.4" >> /etc/resolv.conf
  sudo chmod 644 /etc/resolv.conf

  iniciarDeamonBind
}

function dns2 {

  dir=$(dirname $(which $0))

  sudo ifconfig eth0 10.24.3.134 netmask 255.255.255.0 up

  sudo route add -net 0.0.0.0 netmask 0.0.0.0 gw 10.24.3.129 metric 1

  instalarBind

  echo "###################################################"

  echo "Copiando archivos necesarios para levantar el deamon bind9"

  echo "###################################################"

  chmod -R 777 /etc/bind
  sudo cp -R $dir/../../dns/secundario2/* /etc/bind/
  sudo chattr -i /etc/resolv.conf
  sudo chmod 777 /etc/resolv.conf
  echo "Agregando la direccion IP de DNS1 al archivo /etc/resolv.conf..."
  echo "search riocolorado.chubut.dc.fi.uba.ar" >> /etc/resolv.conf 
  echo "nameserver 10.24.3.134" >> /etc/resolv.conf
  sudo chmod 644 /etc/resolv.conf

  iniciarDeamonBind
}

function dnsroot {

  dir=$(dirname $(which $0))

  sudo ifconfig eth5 10.24.1.5 netmask 255.255.255.128 up
  
  sudo route add -net 0.0.0.0 netmask 0.0.0.0 gw 10.24.1.1 metric 1

  instalarBind

  echo "###################################################"
  
  echo "Copiando archivos necesarios para levantar el deamon bind9"

  echo "###################################################"

  chmod -R 777 /etc/bind
  sudo cp -R $dir/../../dns/root/* /etc/bind/
  sudo chattr -i /etc/resolv.conf
  sudo chmod 777 /etc/resolv.conf
  echo "Agregando la direccion IP de DNS1 al archivo /etc/resolv.conf..."
  echo "search riocolorado.chubut.dc.fi.uba.ar" >> /etc/resolv.conf 
  echo "nameserver 10.24.1.5" >> /etc/resolv.conf
  sudo chmod 644 /etc/resolv.conf


  iniciarDeamonBind
  
}

if [ -z "$1" ] || [ "$1" == "-h" ]
then

  help

elif [ "$1" == "dnsroot" ]
then

  dnsroot

elif [ "$1" == "dns1" ]
then

  dns1

elif [ "$1" == "dns2" ]
then

  dns2

else

  help

fi
