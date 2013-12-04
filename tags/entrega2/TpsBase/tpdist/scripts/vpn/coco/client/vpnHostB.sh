#hostB
# $1 -> Ip del servidor

openvpn --config ./cliente.conf --remote $1 --port 2008 --ifconfig 10.10.5.6 255.255.255.0
