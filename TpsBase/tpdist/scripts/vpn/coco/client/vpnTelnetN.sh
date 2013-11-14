#telnet N
# $1 -> Ip del servidor

openvpn --config ./cliente.conf --remote $1 --port 2006 --ifconfig 10.24.1.65 255.255.255.224
