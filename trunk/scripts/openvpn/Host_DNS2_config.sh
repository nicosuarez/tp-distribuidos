#!/bin/bash

. ./ip_port.sh
. ./functions.sh

godMode

if [ $# -lt 1 ]
then
	echo -e "Debe especificar la interfaz del host."
	exit 0
fi

log "Iniciando configuración automática del DNS 2..."

INTF=$1
export "$INTF"

stopServices

removeProxy
killTunnels
cleanInterface
cleanRoutes

tunnel $DNS2_PORT $DNS2_GNS3_PORT $GNS3_IP $DNS2_INTF_IP $GNS3_MASK "tap0"
setupHost $DNS2_TAP_IP $DNS2_TAP_MASK $DNS2_TAP_BRCST

addDefaultGateway $DNS2_GTWY

setupDNS "DNS2"

end

exit 0

