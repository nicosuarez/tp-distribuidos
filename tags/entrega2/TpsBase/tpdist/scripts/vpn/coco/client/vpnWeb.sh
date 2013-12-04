#webserver
# $1 -> Ip del servidor


openvpn --config ./cliente.conf --remote $1 --port 2004 --ifconfig 192.168.8.71 255.255.255.192
