#!/bin/bash

#verifica si ftp está instalado y, en caso negativo, lo instala.
installed=`dpkg -s vsftpd|grep installed`

echo "Verificando que vsftpd este instalado..."
if [ "" == "$installed" ]; then
	echo "Error: vsftpd no esta instalado!"
	echo "Instalando vsftpd..."
	sudo apt-get --force-yes --yes install vsftpd
else
	echo "vsftpd instalado!"
fi

sudo cp ./init/vsftpd.conf /etc/vsftpd.conf

sudo service vsftpd stop
sudo service vsftpd start
