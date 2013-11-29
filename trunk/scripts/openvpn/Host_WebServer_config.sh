#!/bin/bash

. ./ip_port.sh
. ./functions.sh

godMode

if [ $# -lt 1 ]
then
	echo -e "Debe especificar la interfaz del host."
	exit 0
fi

log "Iniciando configuración automática del WebServer..."

INTF=$1
export "$INTF"

stopServices

removeProxy
killTunnels
cleanInterface
cleanRoutes

tunnel $WEBSERVER_PORT $WEBSERVER_GNS3_PORT $GNS3_IP $WEBSERVER_INTF_IP $GNS3_MASK "tap0"
setupHost $WEBSERVER_TAP_IP $WEBSERVER_TAP_MASK $WEBSERVER_TAP_BRCST

startWebSever

log "---------------RUTAS-------------------..."
VRRP="192.168.8.4"
R12="192.168.8.1"

addRoute $REDHONDA $REDMASCHONDA $VRRP
addRoute $REDYAMAHA $REDMASCYAMAHA $VRRP
addRoute $REDKAWASAKI $REDMASCKAWASAKI $VRRP
addRoute $REDSUSUKI $REDMASCSUSUKI $VRRP
addRoute $REDVESPA $REDMASCVESPA $VRRP
addRoute $REDHDAVIDSON $REDMASCHDAVIDSON $VRRP
addRoute $REDDUCATI $REDMASCDUCATI $R12
addRoute $REDDERBI $REDMASCDERBI $VRRP
addRoute $REDGILERA $REDMASCGILERA $R12
addRoute $REDMOTOMEL $REDMASCMOTOMEL $R12
addRoute $REDBMW $REDMASCBMW $R12
addRoute $REDAPRILIA $REDMASCAPRILIA $R12
addRoute $REDAZEL $REDMASCAZEL $R12
addRoute $REDKTM $REDMASCKTM $R12
addRoute $REDZANELLA $REDMASCZANELLA $R12

addDefaultGateway $WEBSERVER_GTWY
configureDNS $DOMAIN $SEARCH $WEBSERVER_NS
log "---------------Fin de RUTAS-------------------..." 




end

exit 0

