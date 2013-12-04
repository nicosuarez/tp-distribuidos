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

log "---------------RUTAS-------------------..."

VRRP="10.10.5.5"
R4="10.10.5.3"
R5="10.10.5.4"

addRoute $REDHONDA $REDMASCHONDA $VRRP
addRoute $REDYAMAHA $REDMASCYAMAHA $VRRP
addRoute $REDKAWASAKI $REDMASCKAWASAKI $VRRP
addRoute $REDSUSUKI $REDMASCSUSUKI $VRRP
addRoute $REDVESPA $REDMASCVESPA $VRRP
addRoute $REDHDAVIDSON $REDMASCHDAVIDSON $R5
addRoute $REDDUCATI $REDMASCDUCATI $R5
addRoute $REDDERBI $REDMASCDERBI $R5
addRoute $REDGILERA $REDMASCGILERA $R4
addRoute $REDMOTOMEL $REDMASCMOTOMEL $R4
addRoute $REDBMW $REDMASCBMW $R5
addRoute $REDAPRILIA $REDMASCAPRILIA $R5
addRoute $REDAZEL $REDMASCAZEL $R5
addRoute $REDKTM $REDMASCKTM $R4

log "---------------Fin de RUTAS-------------------..."

addDefaultGateway $HOSTC_GTWY
configureDNS $DOMAIN $SEARCH $HOSTC_NS

end

exit 0

