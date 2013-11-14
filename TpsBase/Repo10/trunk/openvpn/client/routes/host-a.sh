#revisar el VRRP porque las que tienen gw = 10.34.6.225 (IP virtual), están mandando por .226 primero y despues redirecciona a .227

sudo route add -net 10.11.3.0 netmask 255.255.255.224 gw 10.34.6.225 dev tap0
sudo route add -net 10.34.13.0 netmask 255.255.255.0 gw 10.34.6.225 dev tap0
sudo route add -net 10.11.3.64 netmask 255.255.255.192 gw 10.34.6.225 dev tap0
sudo route add -net 10.11.2.0 netmask 255.255.255.0 gw 10.34.6.225 dev tap0
sudo route add -net 172.3.1.192 netmask 255.255.255.252 gw 10.34.6.225 dev tap0
sudo route add -net 10.11.3.32 netmask 255.255.255.224 gw 10.34.6.225 dev tap0
sudo route add -net 172.3.1.196 netmask 255.255.255.252 gw 10.34.6.225 dev tap0
sudo route add -net 10.34.1.0 netmask 255.255.255.0 gw 10.34.6.225 dev tap0
sudo route add -net 10.34.6.176 netmask 255.255.255.252 gw 10.34.6.225 dev tap0
sudo route add -net 172.3.1.200 netmask 255.255.255.252 gw 10.34.6.225 dev tap0
sudo route add -net 10.34.6.180 netmask 255.255.255.252 gw 10.34.6.228 dev tap0
sudo route add -net 130.43.1.0 netmask 255.255.255.252 gw 10.34.6.228 dev tap0
sudo route add -net 130.43.1.4 netmask 255.255.255.252 gw 10.34.6.228 dev tap0
sudo route add -net 10.34.6.192 netmask 255.255.255.224 gw 10.34.6.228 dev tap0
sudo route add -net 10.34.6.144 netmask 255.255.255.240 gw 10.34.6.228 dev tap0
sudo route add -net 10.34.6.160 netmask 255.255.255.240 gw 10.34.6.228 dev tap0
sudo route add -net 192.168.3.0 netmask 255.255.255.0 gw 10.34.6.228 dev tap0
sudo route add -net 10.34.6.128 netmask 255.255.255.240 gw 10.34.6.228 dev tap0
sudo route add -net 10.9.2.192 netmask 255.255.255.252 gw 10.34.6.228 dev tap0

