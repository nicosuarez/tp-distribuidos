# Configuracion de los cliente OpenVPN

1. Editar el archivo *up.sh* para establecer el valor de la variable *OPENVPN_SERVER* con la ip de la PC que está corriendo la topología.
   
   OPENVPN_SERVER=

2. Ejecutar el script *up.sh* con alguno de los siguientes parámetros:
   - dns1
   - dns2
   - dns-root
   - ftp
   - web
   - telnet-h     ; todavía queda ver como se deben configurar
   - telnet-r	  ; las interfaces de este servidor.
   - host-a
   - host-b
   - host-c

   Ejemplo:

   $ sudo ./up.sh host-a

3. Para dar de baja el cliente se debe ejecutar el script *down.sh* sin parámetros.
   
   $ ./down.sh