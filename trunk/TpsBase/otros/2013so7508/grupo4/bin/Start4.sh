#!/bin/bash

# Recibe como parametro el nombre del proceso a iniciar
# Si existe un proceso con ese nombre, no hace nada

# Salidas:
# 0: Ejecucion satisfactoria
# 1: No se recibio ningun parametro
# 2: Se intento iniciar un proceso ya existente

CANT_PARAM=$#
NOMBRE_PROC=$1

#Verifica que se reciba algun parametro
verificarParametros() {
	if [ "$CANT_PARAM" -eq 0 ] ; then
		echo "Se debe pasar al menos un parametro indicando el nombre del proceso a iniciar."
		./Glog4.sh "Se debe pasar al menos un parametro indicando el nombre del proceso a iniciar." "ERROR" "Start4"
		exit 1
	fi
}

#Verifica si el proceso que se desea iniciar ya existe
verificarExistencia() {
	if [ "$NOMBRE_PROC" = "$( ps -A | grep $NOMBRE_PROC | awk ' NR==1 {print $4}' )" ] ; then
		EXISTE=1
	else
		EXISTE=0
	fi
}


verificarParametros
verificarExistencia

if [ $EXISTE -eq 1 ] ; then
	#Logeo e informo que ya esta en ejecucion el proceso que se quiere iniciar
	echo "El proceso ya se encontraba en ejecucion. No se inicio ningun proceso"
	./Glog4.sh "El proceso ya se encontraba en ejecucion. No se inicio ningun proceso" "MENSAJE" "Start4"
	exit 2
else
	#Se inicia el proceso en background
	start-stop-daemon -b -d .  -S -x $NOMBRE_PROC 2> /dev/null 
fi	
