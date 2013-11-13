#!/bin/bash

#- Codigos de salida del comando:
#~	0: Ejecucion satisfactoria.
#~	1: Instalacion incorrecta. Faltan archivos.

GRUPOBASE=""

while [ ! -d "$GRUPOBASE/conf" ]
do
	GRUPOBASE="$GRUPOBASE../"
done

#~ Obtiene la ruta en donde se encuentra el archivo Inicio4.sh.
SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#~ CONFDIR=$SCRIPT_DIRECTORY/$grupo/"conf"
CONFDIR=$GRUPOBASE"conf"

#~ Se logea un mensaje indicando que comenzo la ejecucion del comando.
logearInicioEjecucion() {
	if [ ! -x Glog4.sh ] ; then
		chmod u+x Glog4.sh
	fi
	./Glog4.sh "Comando Inicio4 Inicio de Ejecución" "HEADER" "Inicio4"
}

#~ Se logea un mensaje indicando que comenzo la ejecucion del comando.
logearFinEjecucion() {
	./Glog4.sh "Comando Inicio4 Fin de Ejecución" "HEADER" "Inicio4"
}

#~ Se logea un mensaje indicando que el archivo recibido no existe.
logearArchivoFaltante() {
	./Glog4.sh "No se ha encontrado el archivo $@" "ERROR" "Inicio4"
}

clrscr(){
	printf "\033c"
}

#~ Extrae las variables de ambiente seteadas por el comando Instal4.sh
extraerVariablesDeInstalacion(){

	local cont=0
	#extraemos el dir de instalacion
	read base < "$CONFDIR/Instal4.conf"
	IFS=$'='
	for palabra in $linea; do	
		if [ $cont -eq 1 ];then
			$grupo=$palabra
		fi
		let cont++
	done
	
	cont=0
	while read -r linea      
	do
		#Transformamos la linea en tokens
		IFS=$'='
		for aux in $linea; do	
			#extraemos solo los dirs y datos
			if [ $cont -eq 1 ];then
				dirs=$dirs" "$aux	
			fi	
			let cont++
		done
		cont=0
		IFS=$'\n'     
	done < "$CONFDIR/Instal4.conf"
	
	#~ TODO: grupo
	BINDIR=$(echo $dirs | cut -d " " -f 4)
	MAEDIR=$(echo $dirs | cut -d " " -f 5)
	ARRIDIR=$(echo $dirs | cut -d " " -f 6)
	ACEPDIR=$(echo $dirs | cut -d " " -f 7)
	RECHDIR=$(echo $dirs | cut -d " " -f 8)
	PROCDIR=$(echo $dirs | cut -d " " -f 9)
	REPODIR=$(echo $dirs | cut -d " " -f 10)
	LOGDIR=$(echo $dirs | cut -d " " -f 11)
	LOGEXT=$(echo $dirs | cut -d " " -f 12)
	LOGSIZE=$(echo $dirs | cut -d " " -f 13)
	DATASIZE=$(echo $dirs | cut -d " " -f 14)
	
}

#~ Exporta las variables de ambiente seteadas por el comando Instal4.sh
exportarVariablesDeAmbiente() {
	
	export MAEDIR=$GRUPOBASE$MAEDIR
	export BINDIR=$GRUPOBASE$BINDIR
	export ARRIDIR=$GRUPOBASE$ARRIDIR
	export ACEPDIR=$GRUPOBASE$ACEPDIR
	export RECHDIR=$GRUPOBASE$RECHDIR
	export PROCDIR=$GRUPOBASE$PROCDIR
	export REPODIR=$GRUPOBASE$REPODIR
	export LOGDIR=$GRUPOBASE$LOGDIR
	export CONFDIR
	export DATASIZE
	export LOGEXT
	export LOGSIZE
	#~ TODO: grupo
	
}

#~ Se verifica que existan los archivos T1.tab, T2.tab, PPI.mae y p-s.mae.
#~ Se verifica que existan los comandos Instal4.sh.
verificarInstalacion() {
	
	local INSTALACION_CORRECTA=true
	if [ -z "$CONFDIR" ] || [ ! -f $CONFDIR/T1.tab ] ; then
		INSTALACION_CORRECTA=false
		logearArchivoFaltante $CONFDIR/T1.tab
	fi
	if [ -z "$CONFDIR" ] || [ ! -f $CONFDIR/T2.tab ] ; then
		INSTALACION_CORRECTA=false
		logearArchivoFaltante $CONFDIR/T2.tab
	fi
	if [ -z "$GRUPOBASE$MAEDIR" ] || [ ! -f $GRUPOBASE$MAEDIR/PPI.mae ] ; then
		INSTALACION_CORRECTA=false
		logearArchivoFaltante $MAEDIR/PPI.mae
	fi
	if [ -z "$GRUPOBASE$MAEDIR" ] || [ ! -f $GRUPOBASE$MAEDIR/p-s.mae ] ; then
		INSTALACION_CORRECTA=false
		logearArchivoFaltante $MAEDIR/p-s.mae
	fi
	
	if [ ! -f Detecta4.sh ] ; then
		INSTALACION_CORRECTA=false
		logearArchivoFaltante "/Detecta4.sh"
	fi
	
	if [ ! -f Glog4.sh ] ; then
		INSTALACION_CORRECTA=false
		logearArchivoFaltante "/Glog4.sh"
	fi
	
	if [ ! -f Interprete.sh ] ; then
		INSTALACION_CORRECTA=false
		logearArchivoFaltante "/Interprete.sh"
	fi
	
	if [ ! -f Mov4.sh ] ; then
		INSTALACION_CORRECTA=false
		logearArchivoFaltante "/Mov4.sh"
	fi
	
	if [ ! -f Reporte4.pl ] ; then
		INSTALACION_CORRECTA=false
		logearArchivoFaltante "/Reporte4.pl"
	fi
	
	if [ ! -f Start4.sh ] ; then
		INSTALACION_CORRECTA=false
		logearArchivoFaltante "/Start4.sh"
	fi
	
	if [ ! -f Stop4.sh ] ; then
		INSTALACION_CORRECTA=false
		logearArchivoFaltante "/Stop4.sh"
	fi
	
	if [ ! -f Vlog4.sh ] ; then
		INSTALACION_CORRECTA=false
		logearArchivoFaltante "/Vlog4.sh"
	fi
	
	echo $INSTALACION_CORRECTA
	
}

#~ Se logea un mensaje indicando que la instalacion no se encuentra completa.
logearInstalacionIncompleta() {
	./Glog4.sh "La instalacion esta incompleta. Para solucionar el problema debe correr el comando Instal4" "ERROR" "Inicio4"
}

#~ Se logea un mensaje indicando que la instalacion se encuentra completa.
logearInstalacionCompleta() {
	./Glog4.sh "El sistema se ha instalado correctamente y se encuentra completo." "MENSAJE" "Inicio4"
}

#~ Se logea un mensaje indicando que el comando recibido no cuenta con suficientes permisos para ser ejecutado.
logearPermisoIncorrecto() {
	./Glog4.sh "El siguiente comando no cuenta con suficientes permisos para ser ejecutado $@" "ERROR" "Inicio4"
}

#~ Se logea un mensaje indicando que se modificaron los permisos del archivo recibido.
logearCambioPermiso() {
	./Glog4.sh "Seteando permiso de ejecucion al comando $@" "MENSAJE" "Inicio4"
}

#~ Verifica que los comandos del sistema tengan permisos de ejecucion.
verificarPermisos() {
	
	local PERMISOS_CORRECTOS=true
	if [ ! -x Instal4.sh ] ; then
		PERMISOS_CORRECTOS=false
		logearPermisoIncorrecto "/Instal4.sh"
	fi
	
	if [ ! -x Glog4.sh ] ; then
		PERMISOS_CORRECTOS=false
		logearPermisoIncorrecto "/Glog4.sh"
	fi
	
	if [ ! -x Mov4.sh ] ; then
		PERMISOS_CORRECTOS=false
		logearPermisoIncorrecto "/Mov4.sh"
	fi

	if [ ! -x Vlog4.sh ] ; then
		PERMISOS_CORRECTOS=false
		logearPermisoIncorrecto "/Vlog4.sh"
	fi

	if [ ! -x Detecta4.sh ] ; then
		PERMISOS_CORRECTOS=false
		logearPermisoIncorrecto "/Detecta4.sh"
	fi

	if [ ! -x Interprete.sh ] ; then
		PERMISOS_CORRECTOS=false
		logearPermisoIncorrecto "/Interprete.sh"
	fi

	if [ ! -x Start4.sh ] ; then
		PERMISOS_CORRECTOS=false
		logearPermisoIncorrecto "/Start4.sh"
	fi

	if [ ! -x Stop4.sh ] ; then
		PERMISOS_CORRECTOS=false
		logearPermisoIncorrecto "/Stop4.sh"
	fi

	if [ ! -x Reporte4.pl ] ; then
		PERMISOS_CORRECTOS=false
		logearPermisoIncorrecto "/Reporte4.pl"
	fi
	
	echo $PERMISOS_CORRECTOS
}

#~ Setea los permisos de ejecucion para los comandos del sistema.
setearPermisos() {
	
	if [ ! -x Instal4.sh ] ; then
		logearCambioPermiso "/Instal4.sh"
		chmod u+x $SCRIPT_DIRECTORY/Instal4.sh
	fi
	
	if [ ! -x Glog4.sh ] ; then
		logearCambioPermiso "/Glog4.sh"
		chmod u+x $SCRIPT_DIRECTORY/Glog4.sh
	fi
	
	if [ ! -x Mov4.sh ] ; then
		logearCambioPermiso "/Mov4.sh"
		chmod u+x $SCRIPT_DIRECTORY/Mov4.sh
	fi

	if [ ! -x Vlog4.sh ] ; then
		logearCambioPermiso "/Vlog4.sh"
		chmod u+x $SCRIPT_DIRECTORY/Vlog4.sh
	fi

	if [ ! -x Detecta4.sh ] ; then
		logearCambioPermiso "/Detecta4.sh"
		chmod u+x $SCRIPT_DIRECTORY/Detecta4.sh
	fi

	if [ ! -x Interprete.sh ] ; then
		logearCambioPermiso "/Interprete.sh"
		chmod u+x $SCRIPT_DIRECTORY/Interprete.sh
	fi

	if [ ! -x Start4.sh ] ; then
		logearCambioPermiso "/Start4.sh"
		chmod u+x $SCRIPT_DIRECTORY/Start4.sh
	fi

	if [ ! -x Stop4.sh ] ; then
		logearCambioPermiso "/Stop4.sh"
		chmod u+x $SCRIPT_DIRECTORY/Stop4.sh
	fi

	if [ ! -x Reporte4.pl ] ; then
		logearCambioPermiso "/Reporte4.pl"
		chmod u+x $SCRIPT_DIRECTORY/Reporte4.pl
	fi
	
}

#~ Se logea un mensaje indicando que los permisos de ejecucion son incorrectos.
logearPermisosIncorrectos() {
	./Glog4.sh "Los comandos necesarios para la ejecucion del programa no cuentan con permisos suficientes." "ERROR" "Inicio4"
}

#~ Se logea un mensaje indicando que los permisos de ejecucion son correctos.
logearPermisosCorrectos() {
	./Glog4.sh "Los comandos necesarios para la ejecucion del programa cuentan con permisos suficientes." "MENSAJE" "Inicio4"
}

#~ Devuelve true si esta seteado el PATH o false si no lo está.
verificarVariablesAmbienteSeteadas() {
	
	local VARIABLES_SETEADAS=true
	if [[ ! :$PATH: == *:"$SCRIPT_DIRECTORY":* ]] ; then
		VARIABLES_SETEADAS=false
	fi
	
	if [ ! -n "$CANLOOP" ] ; then
		VARIABLES_SETEADAS=false
	fi
	
	if [ ! -n "$TESPERA" ] ; then
		VARIABLES_SETEADAS=false
	fi
	
	echo $VARIABLES_SETEADAS
	
}

#~ Agrega la carpeta en donde se encuentra el script al PATH.
setearVariablesAmbiente() {
	
	if [[ :$PATH: == *:"$SCRIPT_DIRECTORY":* ]] ; then
		echo $SCRIPT_DIRECTORY" ya pertenece al PATH"
	else
		echo "Agregando "$SCRIPT_DIRECTORY" al PATH"
		export PATH=$PATH:$SCRIPT_DIRECTORY
	fi
	
}

#~ Se le pide al usuario que ingrese un valor para CANLOOP que sea positivo.
usuarioIngresaCanloop() {
	
	
	read -p "Cantidad de Ciclos de Detecta4 ? (100 ciclos) "
	local VALOR_INGRESADO=$REPLY
	while (($VALOR_INGRESADO < 0)) ; do
		./Glog4.sh "CANLOOP debe ser un numero positivo. Usuario ingresa: $VALOR_INGRESADO" "WARNING" "Inicio4"
		read -p "Debe ingresar un numero positivo: "
		VALOR_INGRESADO=$REPLY
	done
	
	CANLOOP=$REPLY
	./Glog4.sh "Usuario ingresa CANLOOP=$CANLOOP" "MENSAJE" "Inicio4"
	
}

#~ Se le pide al usuario que ingrese un valor para TESPERA que sea positivo.
usuarioIngresaTespera() {
	
	read -p "Tiempo de espera entre ciclos? (1 minuto) "
	local VALOR_INGRESADO=$REPLY
	while (($VALOR_INGRESADO < 1)) ; do
		./Glog4.sh "TESPERA debe ser mayor a 1 (minuto). Usuario ingresa: $REPLY" "WARNING" "Inicio4"
		echo "El tiempo minimo de espera es 1 (minuto)."
		read -p "Ingrese un tiempo de espera valido: "
		VALOR_INGRESADO=$REPLY
	done
	
	TESPERA=$REPLY
	./Glog4.sh "Usuario ingresa TESPERA=$TESPERA" "MENSAJE" "Inicio4"
	
}

#~ Se exportan las variables que se setearon.
exportarVariablesSeteadas() {
	
	./Glog4.sh "Exportando TESPERA=$TESPERA y CANLOOP=$CANLOOP" "MENSAJE" "Inicio4"
	export TESPERA
	export CANLOOP
	
}

#~ Se le pide al usuario que decida si quiere ejecutar el comando Detecta4 o no.
usuarioIngresaComandoDetecta() {
	
	read -p "Desea efectuar la activacion  de Detecta4? Si - No: "
	local VALOR_INGRESADO=$REPLY
	while [ $VALOR_INGRESADO != si ] && [ $VALOR_INGRESADO != Si ] && [ $VALOR_INGRESADO != no ] && [ $VALOR_INGRESADO != No ] && [ $VALOR_INGRESADO != SI ] && [ $VALOR_INGRESADO != NO ]; do
		./Glog4.sh "Inicio del comando Detecta4. El usuario ingresa una opcion invalida: $VALOR_INGRESADO" "WARNING" "Inicio4"
		read -p "Ingrese una opcion valida (Si - No): "
		VALOR_INGRESADO=$REPLY
	done
	
	if [ $VALOR_INGRESADO = si ] || [ $VALOR_INGRESADO = Si ] || [ $VALOR_INGRESADO = SI ]; then
		echo true
	else
		echo false
	fi
	
}

#~ Muestra por pantalla la lista de archivos en el directorio recibido.
mostrarArchivosDirectorio() {
	
	for file in $@
	do
		if [[ -f $file ]]; then
			echo " - "$file
		fi
	done
	
}

#~ Muestra el estado del sistema por pantalla.
mostrarEstadoSistema() {
	
	echo "TP SO7508 Primer Cuatrimestre 2013. Tema Y Copyright © Grupo 04"
	
	echo "Libreria del Sistema: $SCRIPT_DIRECTORY/$CONFDIR"
	mostrarArchivosDirectorio $SCRIPT_DIRECTORY/$CONFDIR/*
	
	echo "Ejecutables: $SCRIPT_DIRECTORY/$BINDIR"
	mostrarArchivosDirectorio $SCRIPT_DIRECTORY/$BINDIR/*

	echo "Archivos maestros: $SCRIPT_DIRECTORY/$MAEDIR"
	mostrarArchivosDirectorio $SCRIPT_DIRECTORY/$MAEDIR
	
	echo "Directorio de arribo de archivos externos: $SCRIPT_DIRECTORY/$ARRIDIR"
	
	echo "Archivos externos aceptados: $SCRIPT_DIRECTORY/$ACEPDIR"
	
	echo "Archivos externos rechazados: $SCRIPT_DIRECTORY/$RECHDIR"
	
	echo "Archivos procesados: $SCRIPT_DIRECTORY/$PROCDIR"
	
	echo "Reportes de salida: $SCRIPT_DIRECTORY/$REPODIR"
	
	echo "Logs de auditoria del Sistema: $SCRIPT_DIRECTORY/$LOGDIR/<comando>$LOGEXT"
	
	echo "Estado del Sistema: INICIALIZADO"
	
	if [ ! -z "$(pgrep Detecta4)" ] ; then	
		echo "Demonio corriendo bajo el no.: " $(pgrep Detecta4)
	else
		echo "El demonio no esta corriendo."
	fi
	
}

###########################################
########## EJECUCION DEL COMANDO ##########
###########################################

extraerVariablesDeInstalacion
exportarVariablesDeAmbiente

#~ 1 - Inicio de la ejecucion del comando.
logearInicioEjecucion

#~ 2 - Verificar instalador.
INSTALACION_COMPLETA=$(verificarInstalacion)
if $INSTALACION_COMPLETA ; then
	logearInstalacionCompleta
else
	logearInstalacionIncompleta
	#~ logearFinEjecucion
	#~ exit 1
fi
	
#~ Verificacion de los permisos
PERMISOS_CORRECTOS=$(verificarPermisos)
if $PERMISOS_CORRECTOS ; then
	logearPermisosCorrectos
else
	logearPermisosIncorrectos
fi

#~ 3 - Verificar inicializacion de ambiente.
VARIABLES_AMBIENTE_SETEADAS=$(verificarVariablesAmbienteSeteadas)
if $VARIABLES_AMBIENTE_SETEADAS && $PERMISOS_CORRECTOS ; then
	clrscr
	echo "El sistema ya ha sido inicializado. La inicialización terminará."
	./Glog4.sh "El sistema ya ha sido inicializado. La inicialización terminará." "MENSAJE" "Inicio4"
else
	#~ 4 - Verificar instalacion correcta.
	INSTALACION_COMPLETA=$(verificarInstalacion)
	if $INSTALACION_COMPLETA ; then
		logearInstalacionCompleta
	else
		logearInstalacionIncompleta
		#~ logearFinEjecucion
		#~ exit 1
	fi
	
	#~ Setear permisos de ejecucion.
	PERMISOS_CORRECTOS=$(verificarPermisos)
	if $PERMISOS_CORRECTOS ; then
		logearPermisosCorrectos
	else
		logearPermisosIncorrectos
		setearPermisos
	fi

	#~ 5 - Seteando variable PATH y otras variables.
	setearVariablesAmbiente

	#~ 6 - Obteniendo variables de configuracion de DetectaY
	usuarioIngresaCanloop
	usuarioIngresaTespera
	exportarVariablesSeteadas

	#~ 7 - Inicializacion de Detecta4
	INICIAR_DETECTA=$(usuarioIngresaComandoDetecta)
	if $INICIAR_DETECTA ; then
		./Glog4.sh "El usuario desea iniciar el comando Detecta4. Invocando comando..." "MENSAJE" "Inicio4"
		./Detecta4.sh &
	else
		./Glog4.sh "El usuario no desea iniciar el comando Detecta4." "MENSAJE" "Inicio4"
	fi
	
	#~ FINAL - Logeando contenido de variables de ambiente, pid de Detecta4 (pgrep Detecta4) y estado del sistema
	clrscr
fi

mostrarEstadoSistema
#~ Logear fin de ejecucion.
logearFinEjecucion
