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
setupDNS "DNSROOT"


log "---------------RUTAS-------------------..."
R7="10.24.1.1"
R10="10.24.1.2"
R11="10.24.1.3"

addRoute $REDHONDA $REDMASCHONDA $R7
addRoute $REDYAMAHA $REDMASCYAMAHA $R11
addRoute $REDKAWASAKI $REDMASCKAWASAKI $R11
addRoute $REDSUSUKI $REDMASCSUSUKI $R11
addRoute $REDVESPA $REDMASCVESPA $R11
addRoute $REDHDAVIDSON $REDMASCHDAVIDSON $R11
addRoute $REDDUCATI $REDMASCDUCATI $R11
addRoute $REDDERBI $REDMASCDERBI $R11
addRoute $REDMOTOMEL $REDMASCMOTOMEL $R11
addRoute $REDBMW $REDMASCBMW $R10
addRoute $REDAPRILIA $REDMASCAPRILIA $R7
addRoute $REDAZEL $REDMASCAZEL $R7
addRoute $REDKTM $REDMASCKTM $R7
addRoute $REDZANELLA $REDMASCZANELLA $R7

addDefaultGateway $DNSROOT_GTWY
log "---------------Fin de RUTAS-------------------..." 



end

exit 0

