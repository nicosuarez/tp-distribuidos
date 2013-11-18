#revisar el VRRP porque las que tienen gw = 10.34.6.225 (IP virtual), están mandando por .226 primero y despues redirecciona a .227

sudo route add -net 10.24.3.128 netmask 255.255.255.128 gw 10.24.3.129 dev tap8

