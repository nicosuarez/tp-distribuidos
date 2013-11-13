#!/bin/bash

DEFAULT_DIR="dup"

#################################
########## MODO DE USO ##########
#################################

#~ ./Mov4.sh "ruta/al/archivo/origen.extension" "ruta/al/archivo/destino.extension" ["ComandoInvocante(sin .sh)"]
#~ Es indispensable que el archivo destino sea el nombre del archivo y no el directorio en donde se guardara.
#~ Esto lo hice para poder mover un archivo dentro del mismo directorio (rename) sin que se me vuelva muy complicado.

#~ Codigos de error (exit):
#~ 		0: ejecucion correcta.
#~ 		1: falta archivo origen/directorio destino o ambos.
#~ 		2: no existe el archivo origen.
#~ 		3: no existe el directorio destino.

#~ Obtiene el directorio a partir de la ruta de un archivo.
obtenerDirectorioDeRuta() {
	echo $@ | sed 's|\(.*\)/.*|\1|'
}

#~ Obtiene la secuencia de archivo duplicado.
obtenerExtensionSecuencia() {
	echo $@ | sed -e 's/.*[.]\(.*\)/\1/'
}

#~ Logea que el movimiento se efectuo correctamente.
logearMovimientoCorrecto() {
	./Glog4.sh "Se movio el archivo de $ORIGEN a $DESTINO." "MENSAJE" "Mov4"
	if [ $# -eq 3 ] ; then
		./Glog4.sh "Se movio el archivo de $ORIGEN a $DESTINO de manera correcta." "MENSAJE" "$3"
	fi
}

#~ Logea que no se realizo el movimiento, ya que origen y destino son iguales.
logearOrigenDestinoIguales() {
	./Glog4.sh "Origen y destino son iguales. No se movera: $ORIGEN" "WARNING" "Mov4"
	if [ $# -eq 3 ] ; then
		./Glog4.sh "Origen y destino son iguales. No se movera: $ORIGEN" "WARNING" "$3"
	fi
}

#~ Logea el movimiento de un archivo duplicado una unica vez.
logearPrimerDuplicado() {
	./Glog4.sh "Moviendo $ORIGEN a $DIRECTORIO/$DEFAULT_DIR/$NOMBRE_ARCHIVO.1" "MENSAJE" "Mov4"
	if [ $# -eq 3 ] ; then
		./Glog4.sh "Moviendo $ORIGEN a $DIRECTORIO/$DEFAULT_DIR/$NOMBRE_ARCHIVO.1" "MENSAJE" "$3"
	fi
}

#~ Logea el movimiento de un archivo duplicado una unica vez.
logearMovimientoDuplicado() {
	./Glog4.sh "Moviendo $ORIGEN a $DIRECTORIO/$DEFAULT_DIR/$NOMBRE_ARCHIVO.$PROXIMA_SECUENCIA" "MENSAJE" "Mov4"
	if [ $# -eq 3 ] ; then
		./Glog4.sh "Moviendo $ORIGEN a $DIRECTORIO/$DEFAULT_DIR/$NOMBRE_ARCHIVO.$PROXIMA_SECUENCIA" "MENSAJE" "$3"
	fi
}

#~ Obtiene la proxima secuencia del archivo base recibido por parametro.
obtenerProximaSecuencia() {
	local MAX_SECUENCIA=0
	for file in "$@*" ; do
		local SECUENCIA_ACTUAL=$(obtenerExtensionSecuencia $file)
		if [ "$SECUENCIA_ACTUAL" -ge "$MAX_SECUENCIA" ] ; then
			MAX_SECUENCIA=$SECUENCIA_ACTUAL
		fi
	done
	
	echo $(($MAX_SECUENCIA + 1))
}

###########################################
########## EJECUCION DEL COMANDO ##########
###########################################

#~ Parametros insuficientes.
if [ $# -lt 2 ]
then
	./Glog4.sh "Falta archivo origen/directorio destino o ambos." "ERROR" "Mov4"
	exit 1
fi

ORIGEN=$1
DESTINO=$2
#~ Extraer nombre de archivo de la destino.
NOMBRE_ARCHIVO=$(basename "$2")
DIRECTORIO=$(obtenerDirectorioDeRuta $2)

#~ 1.1: origen = destino.
if [ "$ORIGEN" == "$DESTINO" ] ; then
	logearOrigenDestinoIguales
	exit 0
fi

#~ 1.2: no existe archivo origen.
if [ ! -f "$ORIGEN" ] ; then
	./Glog4.sh "No existe archivo origen: $ORIGEN" "ERROR" "Mov4"
	exit 2
fi

#~ 1.2: no existe directorio destino.
if [ ! -d $DIRECTORIO ] ; then
	./Glog4.sh "No existe directorio destino: $DIRECTORIO" "ERROR" "Mov4"
	exit 3
fi

#~ 1.4: No existe archivo destino.
if [ ! -f "$DESTINO" ] ; then
	mv "$ORIGEN" "$DESTINO"
	logearMovimientoCorrecto
	exit 0
fi

#~ 1.3: Existe archivo destino.
if [ -f "$DESTINO" ] ; then
	#~ 1.3.1: Ver si existe directorio de duplicados. 
	if [ ! -d $DIRECTORIO/$DEFAULT_DIR ] ; then
		#~ 1.3.1.1: Creo directorio de duplicados.
		./Glog4.sh "Creando directorio $DIRECTORIO/$DEFAULT_DIR." "WARNING" "Mov4"
		mkdir $DIRECTORIO/$DEFAULT_DIR
	fi
	#~ 1.3.2: No esta todavia en el directorio de duplicados.
	if [ ! -f $DIRECTORIO/$DEFAULT_DIR/"$NOMBRE_ARCHIVO.1" ] ; then
		mv "$ORIGEN" $DIRECTORIO/$DEFAULT_DIR/"$NOMBRE_ARCHIVO.1"
		logearPrimerDuplicado
		exit 0
	fi
	#~ 1.3.2: Se obtiene el proximo valor de la secuencia unica.
	PROXIMA_SECUENCIA=$(obtenerProximaSecuencia $DIRECTORIO/$DEFAULT_DIR/$NOMBRE_ARCHIVO)
	#~ 1.3.3: Se elimina del directorio original y se lo mueve al nuevo.
	mv "$ORIGEN" $DIRECTORIO/$DEFAULT_DIR/$NOMBRE_ARCHIVO.$PROXIMA_SECUENCIA
	logearMovimientoDuplicado
	exit 0
fi
