#HostC
# $1 -> Ip del servidor

openvpn --config ./cliente.conf --remote $1 --port 2009 --ifconfig 10.92.27.6 255.255.255.128
