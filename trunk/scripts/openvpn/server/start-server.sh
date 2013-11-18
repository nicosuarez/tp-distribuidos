# Generar los taps
#openvpn ./conf/dns-root.conf &
#openvpn ./conf/dns-1.conf &
#openvpn ./conf/dns-2.conf &

openvpn ./conf/host-a.conf &
#openvpn ./conf/host-b.conf &
#openvpn ./conf/host-c.conf &

#openvpn ./conf/telnet-server-h.conf &
#openvpn ./conf/telnet-server-r.conf &

#openvpn ./conf/web-server.conf &

#openvpn ./conf/ftp-server.conf &

echo Dando de alta las interfaces...
sleep 3

# Crear las interfaces de los taps.
#ifconfig tap1 promisc up &
#ifconfig tap2 promisc up &
#ifconfig tap3 promisc up &
#ifconfig tap4 promisc up &
#ifconfig tap5 promisc up &
#ifconfig tap6 promisc up &
#ifconfig tap7 promisc up &
ifconfig tap8 promisc up &
#ifconfig tap9 promisc up &
#ifconfig tap10 promisc up &
