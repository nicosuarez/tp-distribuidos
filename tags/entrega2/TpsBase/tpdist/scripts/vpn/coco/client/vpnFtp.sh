#FTPSERVER
# $1 -> Ip del servidor

openvpn --config ./cliente.conf --remote $1 --port 2003 --ifconfig 10.92.27.1 255.255.255.128
