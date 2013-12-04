#DNS1
# $1 -> Ip del servidor GNS3

openvpn --config ./cliente.conf --remote $1 --port 2000 --ifconfig 10.10.5.5 255.255.255.0
