#!/bin/bash

. ./ip_port.sh
. ./functions.sh

godMode

if [ $# -lt 1 ]
then
	echo -e "Debe especificar la interfaz del host."
	exit 0
fi

log "Iniciando configuración automática del FTP..."

INTF=$1
export "$INTF"

stopServices

removeProxy
killTunnels
cleanInterface
cleanRoutes

tunnel $FTP_PORT $FTP_GNS3_PORT $GNS3_IP $FTP_INTF_IP $GNS3_MASK "tap0"
setupHost $FTP_TAP_IP $FTP_TAP_MASK $FTP_TAP_BRCST

addDefaultGateway $FTP_GTWY
configureDNS $DOMAIN $SEARCH $FTP_NS

startFTP

end

exit 0

# Configuración en /etc/vsftpd.conf
# local_enable=YES -> Autorizar usuarios locales.
# write_enable=YES -> Autorizar que los usuario suban archivos.
# Transferir archivos con comandos get y put, desde el cliente.

