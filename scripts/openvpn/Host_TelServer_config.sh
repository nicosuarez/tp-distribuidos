#!/bin/bash

. ./ip_port.sh
. ./functions.sh

godMode

if [ $# -lt 1 ]
then
	echo -e "Debe especificar la interfaz del host."
	exit 0
fi

log "Iniciando configuración automática del TelServer..."

INTF=$1
export "$INTF"

stopServices

removeProxy
killTunnels
cleanInterface
cleanRoutes

tunnel $TELSERVER1_PORT $TELSERVER1_GNS3_PORT $GNS3_IP $TELSERVER_INTF_IP $GNS3_MASK "tap0"
setupHost $TELSERVER1_TAP_IP $TELSERVER1_TAP_MASK $TELSERVER1_TAP_BRCST
disableMartian

tunnel $TELSERVER2_PORT $TELSERVER2_GNS3_PORT $GNS3_IP "" $GNS3_MASK "tap1"
setupHost $TELSERVER2_TAP_IP $TELSERVER2_TAP_MASK $TELSERVER2_TAP_BRCST
disableMartian

addDefaultGateway $TELSERVER_GTWY
configureDNS $DOMAIN $SEARCH $TELSERVER_NS

startTelSever

end

exit 0

