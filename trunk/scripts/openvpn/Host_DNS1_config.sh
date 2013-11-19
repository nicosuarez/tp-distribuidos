#!/bin/bash

. ./ip_port.sh
. ./functions.sh

godMode

if [ $# -lt 1 ]
then
	echo -e "Debe especificar la interfaz del host."
	exit 0
fi

log "Iniciando configuración automática del DNS 1..."

INTF=$1
export "$INTF"

stopServices

removeProxy
killTunnels
cleanInterface
cleanRoutes

tunnel $DNS1_PORT $DNS1_GNS3_PORT $GNS3_IP $DNS1_INTF_IP $GNS3_MASK "tap0"
setupHost $DNS1_TAP_IP $DNS1_TAP_MASK $DNS1_TAP_BRCST

addDefaultGateway $DNS1_GTWY

setupDNS "DNS1"

end

exit 0

