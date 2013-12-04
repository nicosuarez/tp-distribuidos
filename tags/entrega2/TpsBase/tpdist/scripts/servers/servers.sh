#!/bin/bash
#
# NAME
#       servers - Inicio de servidores
#
# SYNOPSIS
#       servers <servicio>
#
# DESCRIPTION
#       Permite iniciar y detener los servicios.
#       IMPORTANTE: Ejecutar con permisos de root.
#
# EXAMPLES
#       servers apache
#               Inicia/Detiene el servicio Apache Web Server, puerto 80.
#
#       servers telnet
#               Inicia/Detiene el servicio Telnet, puerto 23.
#
#       servers ftp
#               Inicia/Detiene el servicio FTP, puerto 21.
#
# EXIT STATUS
#       0       Ejecución satisfactoria.
#       1       Falló el incio del servicio.
#
# ENVIRONMENT
#       [HTTP_PROXY]
#               Opcional
#

SUDO_PASS="distribuidos"

case "$1" in
	# Apache Web Server
	"apache")
		echo "Apache Web Server"	
		echo "$SUDO_PASS" | sudo -S apt-get -y install apache2
		echo ""
		echo ""
		ps -ef | grep "apache2" | grep -v "grep" > /dev/null
		if [ "$?" -eq "0" ];then
			echo "Apache Web Server está corriendo."
			echo "Deteniendo Apache."
			echo "$SUDO_PASS" | sudo -S  /etc/init.d/apache2 stop
		else
			echo "Apache Web Server no está corriendo."
			echo "Iniciando servidor Web..."
			echo "$SUDO_PASS" | sudo -S  /etc/init.d/apache2 start
		fi
	;;

	# Telnet Server
	"telnet")
		echo "Telnet Server"
		echo "$SUDO_PASS" | sudo -S apt-get -y install telnetd	
		echo ""
		echo ""
		ps -ef | grep "inetd" | grep -v "grep" > /dev/null
		if [ "$?" -eq "0" ];then
			echo "Servidor Telnet está corriendo."
			echo "Deteniendo Telnet."
			echo "$SUDO_PASS" | sudo -S  /etc/init.d/openbsd-inetd stop

		else
			echo "Servidor Telnet no está corriendo."
			echo "Iniciando servidor Telnet..."
			echo "$SUDO_PASS" | sudo -S /etc/init.d/openbsd-inetd start
		fi
	;;
	
	# FTP Server
	"ftp")
		echo "FTP Server"
		echo "$SUDO_PASS" | sudo -S apt-get -y install vsftpd
		echo ""
		echo ""
		ps -ef | grep "vsftpd" | grep -v "grep" > /dev/null
		if [ "$?" -eq "0" ]
		then
			echo "Servidor FTP está corriendo."
			echo "Deteniendo FTP."
			echo "$SUDO_PASS" | sudo -S  /etc/init.d/vsftpd stop
		else
			echo "Servidor FTP no está corriendo."
			echo "Iniciando servidor Ftp..."
			echo "$SUDO_PASS" | sudo -S /etc/init.d/vsftpd start
		fi
	;;

	*)
		echo "Las opciones válidas son: 'apache', 'telnet' o 'ftp'."
	;;
esac
