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

  echo "###################################################"

  echo "Instalando bind9"

  echo "###################################################"

  sudo apt-get install bind9
  
}

function iniciarDeamonBind {

  echo "###################################################"

  echo "Iniciando el deamon bind9"

  echo "###################################################"

  sudo service bind9 restart
  
}

function dns1 {

  dir=$(dirname $(which $0))
  
  instalarBind

  echo "###################################################"

  echo "Copiando archivos necesarios para levantar el deamon bind9"

  echo "###################################################"

  sudo cp -R $dir/../../dns/secundario1/* /etc/bind/

  iniciarDeamonBind

}

function dns2 {

  dir=$(dirname $(which $0))

  instalarBind

  echo "###################################################"

  echo "Copiando archivos necesarios para levantar el deamon bind9"

  echo "###################################################"

  sudo cp -R $dir/../../dns/secundario2/* /etc/bind/

  iniciarDeamonBind

}

function dnsroot {

  dir=$(dirname $(which $0))

  instalarBind

  echo "###################################################"
  
  echo "Copiando archivos necesarios para levantar el deamon bind9"

  echo "###################################################"

  sudo cp -R $dir/../../dns/root/* /etc/bind/

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
