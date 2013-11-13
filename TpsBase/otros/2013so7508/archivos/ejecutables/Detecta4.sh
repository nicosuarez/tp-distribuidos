#!/bin/bash

PSMAE=$MAEDIR/'p-s.mae'

CICLO=1

#~ Logea numero de ciclo
logearCiclo() {
	local NUMERO_DE_CICLO=$1
	./Glog4.sh "Ciclo Nro $NUMERO_DE_CICLO" "MENSAJE" "Detecta4"
}

rechazarArchivo() {
	local NombreArchivo=$1
	local ArchivoYaMovido=$2
	
	if [ "$ArchivoYaMovido" -eq 0 ]; then
		./Mov4.sh "$ARRIDIR/$NombreArchivo" "$RECHDIR/$NombreArchivo" "Detecta4.sh"
	fi
}

existePaisYSistema() {
	local PaisACheckear=$1
	local SistemaACheckear=$2
	
	RetValPais=0	# false
	RetValSistema=0	# false
	RetValAmbos=0	# false
	
	IFS=$'\n'
	
	for linea in $(cat $PSMAE)
	do
		IFS='-' read PAIS_ID PAIS_DESC SIS_ID SIS_DESC <<< "$linea"
		
		if [ $PAIS_ID == $PaisACheckear ] ; then
			RetValPais=1	#true
			
			if [ $SIS_ID == $SistemaACheckear ] ; then
				RetValAmbos=1	#true
			fi
		fi
		
		if [ $SIS_ID == $SistemaACheckear ] ; then
			RetValSistema=1	#true
		fi
	done
}

obtenerDatosArchivo() {
	local NombreArchivo=$1
	
	IFS='-' read Pais Sistema Anio Mes <<< "$NombreArchivo"
}

periodoMayorActual() {
	local Mes=$1
	local Anio=$2
	
	local MesActual=$(date +%m)
	local AnioActual=$(date +%Y)
	
	if [ $Anio -gt $AnioActual ]; then
		RETVAL=1
	fi

	if [ $Anio -lt $AnioActual ]; then
		RETVAL=0
	fi
	
	if [ $Anio -eq $AnioActual ]; then
	
		if [ $Mes -gt $MesActual ]; then
			RETVAL=1
		else
			RETVAL=0
		fi
		
	fi
}

obtenerTipoArchivo() {
	local FILE=$1
	IFS=';' read TYPE EXTRA <<< "$(file -ib $FILE)"
}

procesoEjecutandose() {
	local PROCESO=$1
	local CANTIDAD_LIMITE=$2

	local PROCESOS="$(ps -e | grep $PROCESO | wc -l)"
	
	if [ $PROCESOS -ge $CANTIDAD_LIMITE ]; then
		RETVAL=1	# true
	else
		RETVAL=0
	fi
}

interpretaEstaEjecutandose() {
	procesoEjecutandose 'Interprete.sh' 1
}

detectaEstaEjecutandose() {
	procesoEjecutandose 'Detecta4.sh' 3
}

hayArchivosParaProcesar() {
	local CANTIDADARCHIVOS="$(ls $ACEPDIR | wc -l)"
	
	if [ $CANTIDADARCHIVOS -eq 0 ]; then
		RETVAL=0
	else
		RETVAL=1
	fi
}

obtenerPIDInterprete() {
	IFS=' ' read PID TTY TIME CMD <<< "$(ps -e | grep 'Interprete')"
}

moverArchivosFormatoValido() {
	# El formato de los archivos es <pais>-<sistema>-<año>-<mes>
	# Ejemplo: A-6-2012-06
	IFS=$'\n'
	FILES=$(ls $ARRIDIR | grep '[A-Z]-[0-9]-[0-9]\{4\}-[0-9][0-9]$')
	for FILE in $FILES
	do
		obtenerDatosArchivo "$FILE"
		existePaisYSistema "$Pais" "$Sistema"
		
		FicheroMovido=0
		
		#Chequeos
		
		#Tipo de archivo invalido
		obtenerTipoArchivo "$ARRIDIR/$FILE"
		if [ $TYPE != 'text/plain' ]; then
			./Glog4.sh "El archivo $FILE no es de texto" "MENSAJE" "Detecta4"
			rechazarArchivo "$FILE" "$FicheroMovido"
			FicheroMovido=1
		fi
		
		#País inexistente
		if [ "$RetValPais" -eq 0 ]; then
			./Glog4.sh "No existe pais en el mae para el archivo $FILE" "MENSAJE" "Detecta4"
			rechazarArchivo "$FILE" "$FicheroMovido"
			FicheroMovido=1
		fi
		
		#Sistema inexistente
		if [ "$RetValSistema" -eq 0 ]; then
			./Glog4.sh "No existe sistema en el mae para el archivo $FILE" "MENSAJE" "Detecta4"
			rechazarArchivo "$FILE" "$FicheroMovido"
			FicheroMovido=1
		fi

		#Año invalido
		if [ "$Anio" -lt 2000 ]; then
			./Glog4.sh "El año es incorrecto para el archivo $FILE" "MENSAJE" "Detecta4"
			rechazarArchivo "$FILE" "$FicheroMovido"
			FicheroMovido=1
		fi
		
		#Mes invalido
		if [ "$Mes" -gt 12 -o "$Mes" -eq 0 ]; then
			./Glog4.sh "El mes es incorrecto para el archivo $FILE" "MENSAJE" "Detecta4"
			rechazarArchivo "$FILE" "$FicheroMovido"
			FicheroMovido=1
		fi
		
		#Periodo mayor al periodo corriente
		periodoMayorActual $Mes $Anio
		if [ $RETVAL -eq 1 ]; then
			./Glog4.sh "El periodo del archivo $FILE es mayor al actual" "MENSAJE" "Detecta4"
			rechazarArchivo "$FILE" "$FicheroMovido"
			FicheroMovido=1
		fi
		
		# Pais y sistema existen en el mae y cumplio las demas condiciones
		if [ "$RetValAmbos" -eq 1 ] && [ "$FicheroMovido" -eq 0 ] ; then
			./Mov4.sh "$ARRIDIR/$FILE" "$ACEPDIR/$FILE" "Detecta4.sh"
			./Glog4.sh "El nombre del archivo $FILE es valido" "MENSAJE" "Detecta4"
		fi
		
	done
}

moverArchivosFormatoInvalido() {
	local FILES=$(ls $ARRIDIR)
	for FILE in $FILES
	do
		./Mov4.sh "$ARRIDIR/$FILE" "$RECHDIR/$FILE" "Detecta4.sh"
		./Glog4.sh "El formato del archivo $FILE no es valido" "MENSAJE" "Detecta4"
	done
}

interpretarArchivosAceptados() {
	hayArchivosParaProcesar
	if [ $RETVAL -eq 1 ]; then
	
		interpretaEstaEjecutandose
		if [ $RETVAL -eq 0 ]; then

			./Interprete.sh &
			obtenerPIDInterprete

			echo "El pid del interprete es $PID"
		fi
	
	fi
}

detectaEstaEjecutandose

if [ $RETVAL -eq 0 ]; then

	while [ $CICLO -le $CANLOOP ]
	do
		./Glog4.sh "Ciclo Nro $CICLO" "MENSAJE" "Detecta4"
	
		moverArchivosFormatoValido
		moverArchivosFormatoInvalido
		interpretarArchivosAceptados
	
		CICLO=$[$CICLO + 1]
	
		sleep $[$TESPERA*60]
	done

else
	echo 'Detecta ya se esta ejecutando'
fi
	
