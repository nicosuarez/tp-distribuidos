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

startTelSever

log "---------------RUTAS-------------------..."
R17="10.24.1.131"
R11="10.24.1.130"
R10="10.24.1.2"
R7="10.24.1.1"

addRoute $REDKAWASAKI $REDMASCKAWASAKI $R17
addRoute $REDSUSUKI $REDMASCSUSUKI $R17
addRoute $REDVESPA $REDMASCVESPA $R17
addRoute $REDDUCATI $REDMASCDUCATI $R11
addRoute $REDDERBI $REDMASCDERBI $R11
addRoute $REDBMW $REDMASCBMW $R10
addRoute $REDAPRILIA $REDMASCAPRILIA $R10
addRoute $REDAZEL $REDMASCAZEL $R10
addRoute $REDKTM $REDMASCKTM $R7
addRoute $REDZANELLA $REDMASCZANELLA $R7
addRoute $REDHDAVIDSON $REDMASCHDAVIDSON $R11
addRoute $REDHONDA $REDMASCHONDA $R17
 
log "---------------Fin de RUTAS-------------------..." 

addDefaultGateway $TELSERVER_GTWY
configureDNS $DOMAIN $SEARCH $TELSERVER_NS

end

exit 0

