#!/bin/bash

#verifica si bind9 esta instalado y, en caso negativo, lo instala.
#function validate_bind9 {
#	echo "Verificando que bind9 este instalado..."	
#	
#	installed=`dpkg -s bind9|grep installed`
#	if [ "" == "$installed" ]; then
#		echo "bind9 no esta instalado!"
#		echo "Instalando bind9..."
#		sudo apt-get --force-yes --yes install bind9
#	else
#		echo "bind9 esta instalado!"
#	fi
#}

#verifica si la carpeta /etc/bind/ existe. En caso afirmativo, la borra.
function validate_bind_folder {
	echo "Verificando si la carpeta /etc/bind/ existe..."

	if [ -d /etc/bind/ ]; then
  		echo "La carpeta /etc/bind/ existe!"
		echo "Borrando la carpeta /etc/bind/ y sus contenidos..."
		sudo rm -rf /etc/bind/
	else
		echo "La carpeta /etc/bind/ no existe!"
	fi
	
	echo "Creando la carpeta /etc/bind/..."
	sudo mkdir /etc/bind/
	sudo chmod 755 /etc/bind/
}

#verifica si el archivo /etc/resolv.conf existe. EN CASO NEGATIVO, HAY QUE CREARLO A MANO (VACIO). Setea los valores default del #archivo /etc/resolv.conf.
function validate_resolvconf_file {
	echo "Verificando que el archivo /etc/resolv.conf exista..."	
	
	if [ -f /etc/resolv.conf ]; then
  		echo "El archivo /etc/resolv.conf existe!"
	else
		echo "El archivo /etc/resolv.conf no existe! --> CREAR UNO VACIO!!!"
		exit 1
	fi
	
	sudo chattr -i /etc/resolv.conf
	sudo chmod 777 /etc/resolv.conf
	echo "# Dynamic resolv.conf(5) file for glibc resolver(3) generated by resolvconf(8)" > /etc/resolv.conf
	echo "#     DO NOT EDIT THIS FILE BY HAND -- YOUR CHANGES WILL BE OVERWRITTEN" >> /etc/resolv.conf
	echo "nameserver 127.0.0.1" >> /etc/resolv.conf
	sudo chmod 644 /etc/resolv.conf
}

#Carga todos los archivos de configuración default en la carpeta /etc/bind/.
function set_bind_folder_defaults {
	cd ..
	cd ./dns/dnsdefault

	echo "Copiando el contenido default en la carpeta /etc/bind/..."
	sudo cp ./* /etc/bind/

	cd ..
}

#verifica si bind9 esta instalado y, en caso negativo, lo instala.
function restart_service {
	echo "Verificando que bind9 este instalado..."
	
	installed=`dpkg -s bind9|grep ok installed`

	if [ "$installed" == "" ]; then
		echo "bind9 no esta instalado!"
	else
		echo "bind9 esta instalado!"
	fi
	
	echo "Desinstalando bind9..."
	sudo apt-get autoremove bind9
	
	echo "Instalando bind9..."
	sudo apt-get install bind9
}

########## MAIN ##########

validate_resolvconf_file
validate_bind_folder
set_bind_folder_defaults
restart_service
echo "Reiniciando bind9 con la configuracion default..."
/etc/init.d/bind9 restart

exit 0

