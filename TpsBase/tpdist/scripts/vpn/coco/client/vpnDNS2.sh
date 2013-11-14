#DNS2
# $1 -> Ip del servidor

openvpn --config ./cliente.conf --remote $1 --port 2001 --ifconfig 10.24.3.5 255.255.255.0
