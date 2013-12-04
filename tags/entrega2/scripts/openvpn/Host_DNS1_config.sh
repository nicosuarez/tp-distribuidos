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
setupDNS "DNS1"

log "---------------RUTAS-------------------..."
R12="192.168.8.1"
VRRP="192.168.8.4"

addRoute $REDHONDA $REDMASCHONDA $VRRP
addRoute $REDKAWASAKI $REDMASCKAWASAKI $VRRP
addRoute $REDSUSUKI $REDMASCSUSUKI $VRRP
addRoute $REDVESPA $REDMASCVESPA $VRRP
addRoute $REDDUCATI $REDMASCDUCATI $R12
addRoute $REDDERBI $REDMASCDERBI $VRRP
addRoute $REDGILERA $REDMASCGILERA $R12
addRoute $REDMOTOMEL $REDMASCMOTOMEL $R12
addRoute $REDBMW $REDMASCBMW $R12
addRoute $REDAPRILIA $REDMASCAPRILIA $R12
addRoute $REDAZEL $REDMASCAZEL $R12
addRoute $REDKTM $REDMASCKTM $R12
addRoute $REDZANELLA $REDMASCZANELLA $R12

log "---------------Fin de RUTAS-------------------..." 

addDefaultGateway $DNS1_GTWY

end

exit 0

