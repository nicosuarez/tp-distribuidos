#!/bin/bash

. ./ip_port.sh
. ./functions.sh

sudo /etc/init.d/openvpn start

if [ $# -lt 1 ]
then
	echo -e "Debe especificar la interfaz del host."
	exit 0
fi

INTF=$1
export "$INTF"

killTunnels

setupHost $GNS3_IP $GNS3_MASK $GNS3_BRCST

log "Configuración túnel WebServer"
tunnelPromisc "tap5" $WEBSERVER_GNS3_PORT $WEBSERVER_PORT

log "Configuración túnel TelServer 1"
tunnelPromisc "tap6" $TELSERVER1_GNS3_PORT $TELSERVER1_PORT

log "Configuración túnel TelServer 2"
tunnelPromisc "tap7" $TELSERVER2_GNS3_PORT $TELSERVER2_PORT

log "Configuración túnel DNS ROOT"
tunnelPromisc "tap3" $DNSROOT_GNS3_PORT $DNSROOT_PORT

log "Configuración túnel DNS1"
tunnelPromisc "tap1" $DNS1_GNS3_PORT $DNS1_PORT

log "Configuración túnel DNS2"
tunnelPromisc "tap2" $DNS2_GNS3_PORT $DNS2_PORT

log "Configuración túnel FTP"
tunnelPromisc "tap4" $FTP_GNS3_PORT $FTP_PORT

log "Configuración túnel HOST A"
tunnelPromisc "tap8" $HOSTA_GNS3_PORT $HOSTA_PORT

log "Configuración túnel HOST B"
tunnelPromisc "tap9" $HOSTB_GNS3_PORT $HOSTB_PORT

log "Configuración túnel HOST C"
tunnelPromisc "tap0" $HOSTC_GNS3_PORT $HOSTC_PORT

end

exit 0

