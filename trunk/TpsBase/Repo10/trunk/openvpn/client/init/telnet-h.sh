#!/bin/bash

installed=`dpkg -s vsftpd|grep installed`

echo "Verificando que telnetd este instalado..."
if [ "" == "$installed" ]; then
	echo "Error: telnetd no esta instalado!"
	echo "Instalando telnetd..."
	sudo apt-get --force-yes --yes install telnetd
else
	echo "telnetd instalado!"
fi
