#!/bin/bash

. ./ip_port.sh
. ./functions.sh

godMode

if [ $# -lt 1 ]
then
	echo -e "Debe especificar la interfaz del host."
	exit 0
fi

log "Iniciando configuración automática del WebServer..."

INTF=$1
export "$INTF"

stopServices

removeProxy
killTunnels
cleanInterface
cleanRoutes

tunnel $WEBSERVER_PORT $WEBSERVER_GNS3_PORT $GNS3_IP $WEBSERVER_INTF_IP $GNS3_MASK "tap0"
setupHost $WEBSERVER_TAP_IP $WEBSERVER_TAP_MASK $WEBSERVER_TAP_BRCST

startWebSever

addDefaultGateway $WEBSERVER_GTWY
configureDNS $DOMAIN $SEARCH $WEBSERVER_NS

end

exit 0

