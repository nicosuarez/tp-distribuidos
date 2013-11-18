#!/bin/bash

#verifica si apache2 está instalado y, en caso negativo, lo instala.

installed=`dpkg -s apache2|grep installed`

echo "Verificando que apache2 este instalado..."
if [ "" == "$installed" ]; then
	echo "Error: apache2 no esta instalado!"
	echo "Instalando apache2..."
	sudo apt-get --force-yes --yes install apache2
else
	echo "apache2 instalado!"
fi

sudo service apache2 stop

echo Eliminando la configuracion de apache actual en /etc/apache2 ...
sudo rm -rf /etc/apache2
sudo rm -rf /var/www
echo Copiando la configuracion default ...
sudo cp -r ./init/apache2 /etc/.
sudo cp -r ./init/www /var/.

sudo service apache2 start
