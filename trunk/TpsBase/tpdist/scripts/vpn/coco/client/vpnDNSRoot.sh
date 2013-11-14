#DNSRoot
# $1 -> Ip del servidor

openvpn --config ./cliente.conf --remote $1 --port 2002 --ifconfig 10.24.1.133 255.255.255.128
