Tener en cuenta esto para levantar el DNS Root

Los siguientes cambios van en /etc/apparmor.d/usr.sbin.named

/etc/bind/tpdistribuidos/ rw,
/etc/bind/tpdistribuidos/** rw,
/etc/bind/tpdistribuidos/master/** r,
/etc/bind/tpdistribuidos/log/ rw,
/etc/bind/tpdistribuidos/log/** rw,
/etc/bind/** r,

reiniciar el servicio

sudo service apparmor restart

Ademas se debe cambiar el propietario del directorio de log
y de los archivos de configuracion para que perteneza a root y a bind

 