echo Dando de baja todas las intefaces...
ifconfig tap1 down
ifconfig tap2 down
ifconfig tap3 down
ifconfig tap4 down
ifconfig tap5 down
ifconfig tap6 down
ifconfig tap7 down
ifconfig tap8 down
ifconfig tap9 down
ifconfig tap10 down

# Matar todos los procesos
echo Matando todos los procesos de openvpn...
pkill -f openvpn


