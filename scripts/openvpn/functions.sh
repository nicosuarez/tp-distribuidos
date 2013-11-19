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
WEB_FILE="grupo4.html"

function godMode() {
	if [ $UID != 0 ]; then
	    echo "Ud. no es dios, utilice sudo:"
	    echo "sudo $0 $*"
	    exit 99
	fi
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
	log "Configuracón terminada. Que tenga un excelente día!\n"
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

function startTelSever() {
	log "Iniciando el servicio Telnet..."
	startService $TEL_SERVICE
}

function stopTelServer() {
	log "Deteniendo el servicio Telnet..."
	stopService $TEL_SERVICE
}

function startWebSever() {
	log "Iniciando el servicio Web..."
	startService $WEB_SERVICE

	cp ./$WEB_FILE ${WEB_DIR}
	log "Página web $WEB_FILE instalada..."
	wget "http://localhost/grupo4.html"
}

function stopWebServer() {
	log "Deteniendo el servicio Web..."
	stopService $WEB_SERVICE
}

function startFTP() {
	log "Iniciando el servicio FTP..."
	cp $FTP_FILE /etc/$FTP_FILE
	startService $FTP_SERVICE
}

function stopFTP() {
	log "Deteniendo el servicio FTP..."
	stopService $FTP_SERVICE
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

	log "Configurando servicio DNS..."
	stopBind9

	log "Instalando archivos de configuración..."
	cp -f $DNS_NAME/named.conf.* $BIND_DIR
	cp -f $DNS_NAME/*.db $BIND_DIR
	cp -f $DNS_NAME/resolv.conf /etc/
	
	startBind9

	log "Servicio DNS instalado..."
}

function configureDNS() {
	log "Configurando DNS en host..."

	RESOLVCONF="domain $1\nsearch $2\nnameserver $3\n"
	echo -e "$RESOLVCONF" >"$RESOLVCONF_FILE"

	log "DNS configurado..."
}

