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


log "---------------RUTAS-------------------..."
VRRP="10.24.3.133"
R1="10.24.3.129"

addRoute $REDYAMAHA $REDMASCYAMAHA $R1
addRoute $REDKAWASAKI $REDMASCKAWASAKI $R1
addRoute $REDSUSUKI $REDMASCSUSUKI $R1
addRoute $REDVESPA $REDMASCVESPA $R1
addRoute $REDHDAVIDSON $REDMASCHDAVIDSON $R1
addRoute $REDDUCATI $REDMASCDUCATI $R1
addRoute $REDDERBI $REDMASCDUCATI $R1
addRoute $REDGILERA $REDMASCGILERA $R1
addRoute $REDMOTOMEL $REDMASCMOTOMEL $R1
addRoute $REDBMW $REDMASCBMW $VRRP
addRoute $REDAPRILIA $REDMASCAPRILIA $VRRP
addRoute $REDAZEL $REDMASCAZEL $VRRP
addRoute $REDKTM $REDMASCKTM $VRRP
addRoute $REDZANELLA $REDMASCZANELLA $VRRP

addDefaultGateway $HOSTA_GTWY
configureDNS $DOMAIN $SEARCH $HOSTA_NS
log "---------------Fin de RUTAS-------------------..." 


end

exit 0

