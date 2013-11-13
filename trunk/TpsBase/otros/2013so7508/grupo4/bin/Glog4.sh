#!/bin/bash

TIPO_MENSAJE="MENSAJE"
TIPO_HEADER="HEADER"
TIPO_ERROR="ERROR"
TIPO_WARNING="WARNING"
TIPO_SEVERE_ERROR="SEVERE"

MENSAJE=""
TIPO="MENSAJE"
COMANDO=""

if [ -z $LOGDIR ] || [ -z $LOGEXT ] || [ ! -d $LOGDIR ] ; then
	echo "No se ha inicializado el ambiente. Por favor, corra el comando Inicio4"
	exit 2
fi

#~ Si recibe 3 parametros, esta recibiendo el opcional.
if [ $# -eq 3 ]
then
    MENSAJE=$1
    TIPO=$2
    COMANDO=$3
else
    MENSAJE=$1
    COMANDO=$2
fi

#~ ARCHIVO_LOG=$grupo/$LOGDIR/$COMANDO$LOGEXT
ARCHIVO_LOG=$LOGDIR/$COMANDO$LOGEXT

#~ Tipo default es MENSAJE.
if [ $TIPO != $TIPO_MENSAJE ] && [ $TIPO != $TIPO_HEADER ] && [ $TIPO != $TIPO_ERROR ] && [ $TIPO != $TIPO_WARNING ] && [ $TIPO != $TIPO_SEVERE_ERROR ] ; then
	TIPO=$TIPO_MENSAJE
fi

#~ Case HEADER.
if [ $TIPO == $TIPO_HEADER ] ; then
	echo "========== "$MENSAJE" ==========" >> $ARCHIVO_LOG
fi

#~ Case MENSAJE.
if [ $TIPO == $TIPO_MENSAJE ] ; then
	echo "~$USER ($(date +%F" "%T))~ $TIPO ~~~ "$MENSAJE >> $ARCHIVO_LOG
fi

#~ Case ERROR.
if [ $TIPO == $TIPO_ERROR ] ; then
	echo "-$USER ($(date +%F" "%T))-  $TIPO  --- "$MENSAJE >> $ARCHIVO_LOG
fi

#~ Case SEVERE ERROR.
if [ $TIPO == $TIPO_SEVERE_ERROR ] ; then
	echo "#$USER ($(date +%F" "%T))#  $TIPO  ### "$MENSAJE >> $ARCHIVO_LOG
fi

#~ Case WARNING.
if [ $TIPO == $TIPO_WARNING ] ; then
	echo "*$USER ($(date +%F" "%T))* $TIPO *** "$MENSAJE >> $ARCHIVO_LOG
fi

#~ Numero maximo de lineas que puede crecer el log.
NUMBER=100
#~ Espacio que se le deja al log como margen luego de limpiar.
DIFFERENCE=40

reducirTamanioArchivo() {
	
	local ARCHIVO_AUXILIAR="$ARCHIVO.aux"
	local PRIMER_LINEA=$(wc -l < $ARCHIVO_LOG)
	PRIMER_LINEA=$(($PRIMER_LINEA-$NUMBER+$DIFFERENCE))
	
	local LINEA_ACTUAL=0;

	while read LINEA; do
		if [ "$LINEA_ACTUAL" -ge "$PRIMER_LINEA" ] ; then
			echo $LINEA >> $ARCHIVO_AUXILIAR
		fi
		LINEA_ACTUAL=$(($LINEA_ACTUAL+1))
	done < $ARCHIVO_LOG
	
	mv $ARCHIVO_AUXILIAR $ARCHIVO_LOG
	
}

TAMANIO_ARCHIVO=$(stat -c%s "$ARCHIVO_LOG")
TAMANIO_ARCHIVO_KB=$(($TAMANIO_ARCHIVO/1024))

#~ Se chequea si el tamaño del archivo (en lineas) es mayor a la
#~ cantidad limite.
if [ "$TAMANIO_ARCHIVO_KB" -ge "$LOGSIZE" ] ; then
	reducirTamanioArchivo
	echo "~$USER ($(date +%F" "%T))~ $TIPO ~~~ Se limpio el log para que este ocupe $(($NUMBER-$DIFFERENCE)) lineas." >> $ARCHIVO_LOG
fi
