# Verificar que la variable OPENVPN_SERVER fue seteada
OPENVPN_SERVER=157.92.48.129
if [ -z $OPENVPN_SERVER ] ; then
	echo Se debe definir la variable OPENVPN_SERVER:
	echo    export OPENVPN_SERVER=[IP donde se corre la topología]
else
    echo $1
    # Levantar el cliente p2p de openvpn
    sudo openvpn --config ./conf/$1.conf --remote $OPENVPN_SERVER &
    # Esperar un rato para que se cree el tap
    sleep 3
    # Agregar las rutas estáticas para todas las redes de la topología.
    sudo ./routes/$1.sh
    sudo ./init/$1.sh
    sudo ./dns/$1.sh
fi
