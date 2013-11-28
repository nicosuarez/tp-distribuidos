#!/bin/bash

IFCONFIG=`which ifconfig`
ROUTE=`which route`
OPENVPN=`which openvpn`

BIND9_SERVICE="/etc/init.d/bind9"
BIND_DIR="/etc/bind"
RESOLVCONF_FILE="/etc/resolv.conf"
FTP_FILE="vsftpd.conf"
FTP_SERVICE="/etc/init.d/vsftpd"
TEL_SERVICE="/etc/init.d/openbsd-inetd"
WEB_SERVICE="/etc/init.d/apache2"
WEB_DIR="/var/www/"
WEB_FILE="grupo2.html"

function godMode() {
	if [ $UID != 0 ]; then
	    echo "Ud. no es UID 0, utilice sudo:"
	    echo "sudo $0 $*"
	    exit 99
	fi
}

function addRoute() {
	log "Configurando ruta $1 Mascara $2 en $3..."
	$ROUTE add -net $1 netmask $2 $3
}

function addDefaultGateway() {
	log "Configurando Default Gateway en $1..."
	$ROUTE add -net 0.0.0.0 netmask 0.0.0.0 gw $1
}

function setupHost() {
	IP=$1
	MASK=$2
	BRCST=$3

	log "Configurando $INTF del host con IP: $IP, MASK: $MASK y BROADCAST: $BRCST..."
	$IFCONFIG $INTF $IP broadcast $BRCST netmask $MASK
}

function end() {
	log "Configuracón terminada \n"
}

function tunnelPromisc() {
	TAP=$1
	LPORT=$2
	RPORT=$3

	log "Configurando túnel promiscuo con RPORT: $RPORT, LPORT: $LPORT y DEV: $TAP..."
	$OPENVPN --proto udp --lport $LPORT --rport $RPORT --dev $TAP >> openvpn$TAP.log &

	sleep 2

	$IFCONFIG $TAP 0.0.0.0 promisc
}

function tunnel() {
	LPORT=$1
	RPORT=$2
	REMOTE_IP=$3
	LOCAL_IP=$4
	LOCAL_MASK=$5
	TAP=$6

	if [ "$LOCAL_IP" != "" ]
	then
		log "Configurando IP $LOCAL_IP en interface $INTF..."
		$IFCONFIG $INTF $LOCAL_IP netmask $LOCAL_MASK
	fi

	log "Configurando túnel con RPORT: $RPORT, LPORT: $LPORT, REMOTE: $REMOTE_IP y DEV: $TAP..."
	$OPENVPN --proto udp --rport $RPORT --lport $LPORT --remote $REMOTE_IP --dev $TAP > openvpn$TAP.log &

	sleep 2
	
	log "Cambiando interfaz a configurar por $TAP..."
	INTF=$TAP
}

function killTunnels() {
	log "Eliminando túneles actuales..."

	for i in $( ifconfig | grep 'tap' | awk '{print $1}' );
	do
		$IFCONFIG $i down
		cleanInterface $i
	done

	killall $OPENVPN 2> /dev/null

	sleep 2
}

function cleanRoutes() {
	log "Limpiando tabla de ruteo..."
	`ip route flush all`
}

function cleanInterface() {
	CLEAN_INTF=$INTF
	
	if [ $# -eq 1 ]
	then
		CLEAN_INTF=$1
	fi

	log "Limpiando configuración de $CLEAN_INTF..."
	`ip addr flush $CLEAN_INTF`
}

function log() {
	WHEN=$(date "+%H:%M:%S")
	echo -e "\n$WHEN - $1"
}

function disableMartian() {
	log "Deshabilitando Martian Package en $INTF..."
    sysctl net.ipv4.conf.$INTF.rp_filter=0
}

function installTelServer() {
	installed=`dpkg -s vsftpd|grep installed`

	echo "Verificando que telnetd este instalado..."
	if [ "" == "$installed" ]; then
		echo "Error: telnetd no esta instalado!"
		echo "Instalando telnetd..."
		sudo apt-get --force-yes --yes install telnetd
	else
		echo "telnetd instalado!"
	fi
}

function startTelSever() {
	installTelServer
	log "Iniciando el servicio Telnet..."
	startService $TEL_SERVICE
}

function stopTelServer() {
	log "Deteniendo el servicio Telnet..."
	stopService $TEL_SERVICE
}

function installWebServer() {
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
}

function startWebSever() {
	installWebServer
	log "Iniciando el servicio Web..."
	startService $WEB_SERVICE

	cp ./$WEB_FILE ${WEB_DIR}
	log "Página web $WEB_FILE instalada..."
	wget "http://localhost/grupo2.html"
}

function stopWebServer() {
	log "Deteniendo el servicio Web..."
	stopService $WEB_SERVICE
}

function installFTP() {
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
}

function startFTP() {
	installFTP
	log "Iniciando el servicio FTP..."
	cp $FTP_FILE /etc/$FTP_FILE
	startService $FTP_SERVICE
}

function stopFTP() {
	log "Deteniendo el servicio FTP..."
	stopService $FTP_SERVICE
}

function installBind9() {
	echo "Verificando que bind9 este instalado..."
	installed=`dpkg -s bind9 | grep 'ok installed'`
	if [ "$installed" == "" ]; then
		echo "bind9 no esta instalado!"
		sudo apt-get --force-yes --yes install bind9
	else
		echo "bind9 esta instalado!"
	fi  
}

function startBind9() {
	log "Iniciando el servicio Bind9..."
	startService $BIND9_SERVICE
}

function stopBind9() {
	log "Deteniendo el servicio Bind9..."
	stopService $BIND9_SERVICE
}

function startService() {
	SERVICE=$(echo $1 | sed 's|/etc/init.d/||g')
	service $SERVICE start
	if [ $? -ne "0" ]; then
		$1 start
	fi

	service $SERVICE status
	if [ $? -ne "0" ]; then
		$1 status
	fi
}

function stopService() {
	SERVICE=$(echo $1 | sed 's|/etc/init.d/||g')
	service $SERVICE stop
	if [ $? -ne "0" ]; then
		$1 stop
	fi
}

function stopServices() {
	log "Deteniendo servicios activos..."
	stopTelServer
	stopWebServer
	stopFTP
}

function removeProxy() {
	log "Eliminando proxy (http_proxy)"
	export http_proxy=""
}

function setupDNS() {
	DNS_NAME=$1

	installBind9

	log "Configurando servicio DNS..."
	stopBind9

	log "Instalando archivos de configuración..."

	cp -f $DNS_NAME/named.conf $BIND_DIR
	cp -f $DNS_NAME/named.conf.* $BIND_DIR
	cp -f $DNS_NAME/*.rev $BIND_DIR
	cp -f $DNS_NAME/*.db $BIND_DIR
	cp -f $DNS_NAME/db.* $BIND_DIR
	cp -f $DNS_NAME/bind.keys $BIND_DIR
	cp -f $DNS_NAME/resolv.conf /etc/
	chmod 777 /etc/bind -R
	chown root /etc/bind -R
	startBind9

	log "Servicio DNS instalado..."
}

function configureDNS() {
	log "Configurando DNS en host..."

	RESOLVCONF="domain $1\nsearch $2\nnameserver $3\n"
	echo -e "$RESOLVCONF" >"$RESOLVCONF_FILE"

	log "DNS configurado..."
}

