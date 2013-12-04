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

echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter

tunnel $TELSERVER1_PORT $TELSERVER1_GNS3_PORT $GNS3_IP $TELSERVER_INTF_IP $GNS3_MASK "tap0"
setupHost $TELSERVER1_TAP_IP $TELSERVER1_TAP_MASK $TELSERVER1_TAP_BRCST
disableMartian

tunnel $TELSERVER2_PORT $TELSERVER2_GNS3_PORT $GNS3_IP "" $GNS3_MASK "tap1"
setupHost $TELSERVER2_TAP_IP $TELSERVER2_TAP_MASK $TELSERVER2_TAP_BRCST
disableMartian

startTelSever

log "---------------RUTAS-------------------..."
R17="10.24.1.131"
R11="10.24.1.3"
R10="10.24.1.2"
R7="10.24.1.1"
R11Motomel="10.24.1.130"

addRouteTelnet $REDKAWASAKI $REDMASCKAWASAKI $R17 "tap1"
addRouteTelnet $REDSUSUKI $REDMASCSUSUKI $R17 "tap1"
addRouteTelnet $REDVESPA $REDMASCVESPA $R17 "tap1"
addRouteTelnet $REDDUCATI $REDMASCDUCATI $R17 "tap1"
addRouteTelnet $REDDERBI $REDMASCDERBI $R17 "tap1"
addRouteTelnet $REDBMW $REDMASCBMW $R11Motomel "tap1"
addRouteTelnet $REDAPRILIA $REDMASCAPRILIA $R11Motomel "tap1"
addRouteTelnet $REDAZEL $REDMASCAZEL $R11Motomel "tap1"
addRouteTelnet $REDKTM $REDMASCKTM $R11Motomel "tap1"
addRouteTelnet $REDZANELLA $REDMASCZANELLA $R11Motomel "tap1"
addRouteTelnet $REDHDAVIDSON $REDMASCHDAVIDSON $R11Motomel "tap1"
addRouteTelnet $REDHONDA $REDMASCHONDA $R17 "tap1"

addRouteTelnet2 $REDKAWASAKI $REDMASCKAWASAKI $R11 "tap0"
addRouteTelnet2 $REDSUSUKI $REDMASCSUSUKI $R11 "tap0"
addRouteTelnet2 $REDVESPA $REDMASCVESPA $R11 "tap0"
addRouteTelnet2 $REDDUCATI $REDMASCDUCATI $R11 "tap0"
addRouteTelnet2 $REDDERBI $REDMASCDERBI $R11 "tap0"
addRouteTelnet2 $REDBMW $REDMASCBMW $R10 "tap0"
addRouteTelnet2 $REDAPRILIA $REDMASCAPRILIA $R10 "tap0"
addRouteTelnet2 $REDAZEL $REDMASCAZEL $R10 "tap0"
addRouteTelnet2 $REDKTM $REDMASCKTM $R7 "tap0"
addRouteTelnet2 $REDZANELLA $REDMASCZANELLA $R7 "tap0"
addRouteTelnet2 $REDHDAVIDSON $REDMASCHDAVIDSON $R11 "tap0"
addRouteTelnet2 $REDHONDA $REDMASCHONDA $R7 "tap0"
log "---------------Fin de RUTAS-------------------..." 


addRouteTelnet2 "0.0.0.0" "0.0.0.0" $R7 "tap0"
#addRouteTelnet "0.0.0.0" "0.0.0.0" $R17 "tap1"
#addDefaultGateway $TELSERVER_GTWY_GILERA
#addDefaultGateway $TELSERVER_GTWY_MOTOMEL

configureDNS $DOMAIN $SEARCH $TELSERVER_NS

end

exit 0

