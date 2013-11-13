#!/bin/bash

#################################
########## MODO DE USO ##########
#################################

#~ ./Vlog4.sh
#~ -s "palabra o frase a buscar"
#~ -f "comando en cuyo log buscar"
#~ -n "cantidad maxima de lineas a mostrar"
#~ [-i "severidad del mensaje"]

#~ Codigos de salida:
#~ 		0: Ejecucion satistactoria.
#~ 		1: No se recibio string a buscar.
#~ 		2: No se recibio comando a buscar.
#~ 		3: No se recibio cantidad maxima de lineas a mostrar.
#~ 		4: El comando ingresado no ha escrito en el log aun.

SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#~ Cambio el separador de resultados a newline.
IFS=$'\n'

#~ Se logea un mensaje indicando que comenzo la ejecucion del comando.
logearInicioEjecucion() {
	./Glog4.sh "Comando Vlog4 Inicio de Ejecución" "HEADER" "Vlog4"
}

#~ Se logea un mensaje indicando que comenzo la ejecucion del comando.
logearFinEjecucion() {
	./Glog4.sh "Comando Vlog4 Fin de Ejecución" "HEADER" "Vlog4"
}

###########################################
########## EJECUCION DEL COMANDO ##########
###########################################

logearInicioEjecucion

while getopts s:f:n:i: option
do
	case "${option}"
		in
			s) STRING=${OPTARG};;
			f) FILE=${OPTARG};;
			n) NUMBER=${OPTARG};;
			i) IMPORTANCE=${OPTARG};;
	esac
done

#~ No se recibio string a buscar.
if [ -z $STRING ] ; then
	echo "Se debe especificar una palabra o frase a buscar luego de la opcion -s."
	./Glog4.sh "Se debe especificar una palabra o frase a buscar luego de la opcion -s." "ERROR" "Vlog4"
	logearFinEjecucion
	exit 1
fi

#~ No se recibio comando en el cual buscar.
if [ -z $FILE ] ; then
	echo "Se debe especificar un comando en el cual se va a buscar luego de la opcion -f."
	./Glog4.sh "Se debe especificar un comando en el cual se va a buscar luego de la opcion -f." "ERROR" "Vlog4"
	logearFinEjecucion
	exit 2
fi

#~ No se recibio cantidad maxima de lineas a mostrar.
if [ -z $NUMBER ] ; then
	echo "Se debe especificar una cantidad maxima de lineas a mostrar luego de la opcion -n."
	./Glog4.sh "Se debe especificar una cantidad maxima de lineas a mostrar luego de la opcion -n." "ERROR" "Vlog4"
	logearFinEjecucion
	exit 3
fi

#~ ARCHIVO_LOG=$grupo/$LOGDIR/$FILE$LOGEXT
ARCHIVO_LOG=$LOGDIR/$FILE$LOGEXT

if [ ! -f $ARCHIVO_LOG ] ; then
	echo "El comando $FILE no ha generado un archivo de log aun."
	./Glog4.sh "El comando $FILE no ha generado un archivo de log aun." "WARNING" "Vlog4"
	logearFinEjecucion
	exit 4
fi

#~ Se calcula la primer linea que se debe mostrar del output de
#~ grep en base al total de lineas que cumplen el criterio y
#~ la cantidad de lineas que se quieren mostrar.
PRIMER_LINEA=$(grep -iwc "$STRING" $ARCHIVO_LOG | grep -iw "$IMPORTANCE")
PRIMER_LINEA=$(($PRIMER_LINEA-$NUMBER))

#~ Se busca la expresion regular como palabra completa, independientemente
#~ de el tipo de case buscado, en el log del comando recibido.
LINEA_ACTUAL=0
LINEAS_MOSTRADAS=0
for LINEA in `grep -iw "$STRING" $ARCHIVO_LOG | grep -iw "$IMPORTANCE"` ; do
	if [ "$LINEAS_MOSTRADAS" -ge "$NUMBER" ] ; then
		logearFinEjecucion
		exit 0
	fi
	if [ "$LINEA_ACTUAL" -ge "$PRIMER_LINEA" ] ; then
		LINEAS_MOSTRADAS=$(($LINEAS_MOSTRADAS+1))
		echo $LINEA
	fi
	LINEA_ACTUAL=$(($LINEA_ACTUAL+1))
done

logearFinEjecucion
exit 0
