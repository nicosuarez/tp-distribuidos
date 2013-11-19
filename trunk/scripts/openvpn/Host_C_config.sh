#!/bin/bash

. ./ip_port.sh
. ./functions.sh

godMode

if [ $# -lt 1 ]
then
	echo -e "Debe especificar la interfaz del host."
	exit 0
fi

log "Iniciando configuración automática del HOST C..."

INTF=$1
export "$INTF"

stopServices

removeProxy
killTunnels
cleanInterface
cleanRoutes

tunnel $HOSTC_PORT $HOSTC_GNS3_PORT $GNS3_IP $HOSTC_INTF_IP $GNS3_MASK "tap0"
setupHost $HOSTC_TAP_IP $HOSTC_TAP_MASK $HOSTC_TAP_BRCST

addDefaultGateway $HOSTC_GTWY
configureDNS $DOMAIN $SEARCH $HOSTC_NS

end

exit 0

