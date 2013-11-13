#!/bin/bash

#Parametros:
# -n "Nombre del proceso a detener"
# -p "Numero de PID del proceso a detener"

# Salidas:
# 0: Ejecucion satisfactoria
# 1: No se recibio ningun parametro
# 2: Se intento detener un proceso inexistente

CANT_PARAM=$#
PID=0

#Verifica que se reciba algun parametro
verificarParametros() {
	if [ "$CANT_PARAM" -eq 0 ] ; then
		echo "Se debe pasar al menos un parametro indicando el nombre del proceso a detener."
		./Glog4.sh "Se debe pasar al menos un parametro indicando el nombre del proceso a detener." "ERROR" "Stop4"
		exit 1
	fi
}

#Verifica si el proceso que se desea detener existe
verificarExistencia() {
	if [ "$PID" -ge 1 ] && [ "$PID" = "$( ps -A | grep $PID | awk ' NR==1 {print $1}' )" ] ; then
		EXISTE=1
	else
		EXISTE=0
	fi
}

#Obtiene el PID de un proceso a partir de su nombre
obtenerPID() {
	if [ "$NOMBRE_PROC" = "$( ps -A | grep $NOMBRE_PROC | awk ' NR==1 {print $4}' )" ] ; then
		PID="$(ps -A | grep $NOMBRE_PROC | awk '{print $1}')"
	else
		PID=0
	fi
}

#Detiene el proceso si es que el mismo existe
detenerProceso(){
	verificarExistencia
	
	if [ $EXISTE -eq 0 ] ; then
		#Logeo e informo que no existe el proceso
		echo "El proceso que se desea detener no existe"
		./Glog4.sh "El proceso que se desea detener no existe" "MENSAJE" "Stop4"
		exit 2
	else
		kill "$PID" 
		#start-stop-daemon -K -p $PID
	fi	
}


verificarParametros

while getopts n:p: opcion
do
	case "${opcion}"
		in
			p) 	PID=${OPTARG}
				detenerProceso
				exit 0
				;;		
			n) 	NOMBRE_PROC=${OPTARG}
				obtenerPID
				detenerProceso
				exit 0
				;;
	esac
done
