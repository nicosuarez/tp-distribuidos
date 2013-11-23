#!/bin/bash

. ./ip_port.sh
. ./functions.sh

godMode

echo "Dando de baja todas las intefaces..."
stopServices
removeProxy
killTunnels
cleanInterface
cleanRoutes

#ifconfig tap0 down
#ifconfig tap1 down
#ifconfig tap2 down
#ifconfig tap3 down
#ifconfig tap4 down
#ifconfig tap5 down
#ifconfig tap6 down
#ifconfig tap7 down
#ifconfig tap8 down
#ifconfig tap9 down

# Matar todos los procesos
echo "Matando todos los procesos de openvpn..."
pkill -f openvpn

echo "Fin..."


