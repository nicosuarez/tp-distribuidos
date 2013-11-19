#!/bin/bash

. ./ip_port.sh
. ./functions.sh

godMode

if [ $# -lt 1 ]
then
	echo -e "Debe especificar la interfaz del host."
	exit 0
fi

log "Iniciando configuración automática del DNS ROOT..."

INTF=$1
export "$INTF"

stopServices

removeProxy
killTunnels
cleanInterface
cleanRoutes

tunnel $DNSROOT_PORT $DNSROOT_GNS3_PORT $GNS3_IP $DNSROOT_INTF_IP $GNS3_MASK "tap0"
setupHost $DNSROOT_TAP_IP $DNSROOT_TAP_MASK $DNSROOT_TAP_BRCST

addDefaultGateway $DNSROOT_GTWY

setupDNS "DNSROOT"

end

exit 0

