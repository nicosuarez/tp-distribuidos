#!/bin/bash

. ./ip_port.sh
. ./functions.sh

godMode

if [ $# -lt 1 ]
then
	echo -e "Debe especificar la interfaz del host."
	exit 0
fi

log "Iniciando configuración automática del HOST A..."

INTF=$1
export "$INTF"

stopServices

removeProxy
killTunnels
cleanInterface
cleanRoutes

tunnel $HOSTA_PORT $HOSTA_GNS3_PORT $GNS3_IP $HOSTA_INTF_IP $GNS3_MASK "tap0"
setupHost $HOSTA_TAP_IP $HOSTA_TAP_MASK $HOSTA_TAP_BRCST

addDefaultGateway $HOSTA_GTWY
configureDNS $DOMAIN $SEARCH $HOSTA_NS

end

exit 0

