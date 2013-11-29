#!/bin/bash

. ./ip_port.sh
. ./functions.sh

godMode

if [ $# -lt 1 ]
then
	echo -e "Debe especificar la interfaz del host."
	exit 0
fi

log "Iniciando configuración automática del HOST B..."

INTF=$1
export "$INTF"

stopServices

removeProxy
killTunnels
cleanInterface
cleanRoutes

tunnel $HOSTB_PORT $HOSTB_GNS3_PORT $GNS3_IP $HOSTB_INTF_IP $GNS3_MASK "tap0"
setupHost $HOSTB_TAP_IP $HOSTB_TAP_MASK $HOSTB_TAP_BRCST

log "---------------RUTAS-------------------..."

VRRP="10.24.3.67"
addRoute $REDHONDA $REDMASCHONDA $VRRP
addRoute $REDYAMAHA $REDMASCYAMAHA $VRRP
addRoute $REDKAWASAKI $REDMASCKAWASAKI $VRRP
addRoute $REDSUSUKI $REDMASCSUSUKI $VRRP
addRoute $REDVESPA $REDMASCVESPA $VRRP
addRoute $REDHDAVIDSON $REDMASCHDAVIDSON $VRRP
addRoute $REDDUCATI $REDMASCDUCATI $VRRP
addRoute $REDDERBI $REDMASCDERBI $VRRP
addRoute $REDGILERA $REDMASCGILERA $VRRP
addRoute $REDMOTOMEL $REDMASCMOTOMEL $VRRP
addRoute $REDBMW $REDMASCBMW $VRRP
addRoute $REDAPRILIA $REDMASCAPRILIA $VRRP
addRoute $REDAZEL $REDMASCAZEL $VRRP
addRoute $REDKTM $REDMASCKTM $VRRP
addRoute $REDZANELLA $REDMASCZANELLA $VRRP
log "---------------Fin de RUTAS-------------------..."

addDefaultGateway $HOSTB_GTWY
configureDNS $DOMAIN $SEARCH $HOSTB_NS

end

exit 0

