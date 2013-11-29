#!/bin/bash

. ./ip_port.sh
. ./functions.sh

godMode

if [ $# -lt 1 ]
then
	echo -e "Debe especificar la interfaz del host."
	exit 0
fi

log "Iniciando configuración automática del FTP..."

INTF=$1
export "$INTF"

stopServices

removeProxy
killTunnels
cleanInterface
cleanRoutes

tunnel $FTP_PORT $FTP_GNS3_PORT $GNS3_IP $FTP_INTF_IP $GNS3_MASK "tap0"
setupHost $FTP_TAP_IP $FTP_TAP_MASK $FTP_TAP_BRCST

startFTP

log "---------------FIN de Inicio de FTP-------------------..."

log "---------------RUTAS-------------------..."
R7="10.92.27.4"
R8="10.92.27.3"
R9="10.92.27.2"
addRoute $REDHONDA $REDMASCHONDA $R7
addRoute $REDYAMAHA $REDMASCYAMAHA $R7
addRoute $REDKAWASAKI $REDMASCKAWASAKI $R7
addRoute $REDSUSUKI $REDMASCSUSUKI $R7
addRoute $REDVESPA $REDMASCVESPA $R7
addRoute $REDHDAVIDSON $REDMASCHDAVIDSON $R8
addRoute $REDDUCATI $REDMASCDUCATI $R7
addRoute $REDDERBI $REDMASCDERBI $R7
addRoute $REDGILERA $REDMASCGILERA $R7
addRoute $REDMOTOMEL $REDMASCMOTOMEL $R7
addRoute $REDBMW $REDMASCBMW $R9
addRoute $REDAPRILIA $REDMASCAPRILIA $R8
addRoute $REDAZEL $REDMASCAZEL $R7
addRoute $REDKTM $REDMASCKTM $R7
addRoute $REDZANELLA $REDMASCZANELLA $R7

addDefaultGateway $FTP_GTWY
configureDNS $DOMAIN $SEARCH $FTP_NS
log "---------------Fin de RUTAS-------------------..." 


end

exit 0

# Configuración en /etc/vsftpd.conf
# local_enable=YES -> Autorizar usuarios locales.
# write_enable=YES -> Autorizar que los usuario suban archivos.
# Transferir archivos con comandos get y put, desde el cliente.

