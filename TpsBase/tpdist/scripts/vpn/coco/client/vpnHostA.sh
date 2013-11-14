#hostA
# $1 -> Ip del servidor

openvpn --config ./cliente.conf --remote $1 --port 2007 --ifconfig 10.24.1.4 255.255.255.224
