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
setupDNS "DNS2"

log "---------------RUTAS-------------------..."
R1="10.24.3.129"
VRRP="10.24.3.133"

addRoute $REDKAWASAKI $REDMASCKAWASAKI $R1
addRoute $REDSUSUKI $REDMASCSUSUKI $R1
addRoute $REDVESPA $REDMASCVESPA $R1
addRoute $REDDUCATI $REDMASCDUCATI $R1
addRoute $REDDERBI $REDMASCDERBI $R1
addRoute $REDGILERA $REDMASCGILERA $R1
addRoute $REDMOTOMEL $REDMASCMOTOMEL $R1
addRoute $REDBMW $REDMASCBMW $R1
addRoute $REDAPRILIA $REDMASCAPRILIA $VRRP
addRoute $REDAZEL $REDMASCAZEL $VRRP
addRoute $REDKTM $REDMASCKTM $VRRP
addRoute $REDZANELLA $REDMASCZANELLA $VRRP
addRoute $REDHDAVIDSON $REDMASCHDAVIDSON $VRRP
 
log "---------------Fin de RUTAS-------------------..." 

addDefaultGateway $DNS2_GTWY


end

exit 0

