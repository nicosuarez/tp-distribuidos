#telnet
# $1 -> Ip del servidor

openvpn --config ./cliente.conf --remote $1 --port 2005 --ifconfig 10.24.1.129 255.255.255.128
