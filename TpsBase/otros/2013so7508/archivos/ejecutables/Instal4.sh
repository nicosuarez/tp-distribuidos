#!/bin/bash

printHelpAndExit(){
echo "Uso: ./Instal4.sh DIR"
			echo "DIR es la ruta (relativa) del dir donde se instalará el paquete"
			echo "si no se pasa ningún parámetro, la ruta por defecto será grupo4/"
			exit 0
}

#Checkeamos si nos pasaron argumentos
if [ $# -eq 0 ];then
	grupo="grupo4"
else
	 case "$1" in
        -h|--help)
			printHelpAndExit
		 ;;
		 *)
		 	if [ $# -eq 1 ];then
				grupo=$1
			else
				printHelpAndExit
			fi
         ;;
         esac
fi

if [ ! -d $grupo ]; then
		mkdir $grupo
fi

CONFDIR="conf"

#variables a leer del archivo de configuracion
MAEDIR="mae"
BINDIR="bin"
ARRIDIR="arribos"
DATASIZE=100
ACEPDIR="aceptados"
RECHDIR="rechazados"
PROCDIR="procesados"
REPODIR="reportes"
LOGSIZE=400
LOGDIR="log"
LOGEXT=".log"

#directorio donde estan los archivos a instalar
archivos="archivos"
inicializarLog(){
	
	LOG=$grupo/$CONFDIR/Instal4.log
	INSTALCONF=$grupo/$CONFDIR/Instal4.conf
	
	if [ ! -f $LOG ] || [ ! -d $grupo/$CONFDIR ]; then
		# the file does not exist
		if [ ! -d $grupo/$CONFDIR ]; then
			mkdir $grupo/$CONFDIR
		fi	
		logear "Creando archivo de log..."	
		fi
	
	
	logear "Inicio de Ejecución"
	logear "Directorio de configuración: " $grupo/$CONFDIR
	logear "Log del Comando Instal4: " $grupo/$LOG

}

logear(){
	#echo "$@"
	echo "==== "$@" ====" >> $LOG
}


verificarInstalacion(){
	if [ ! -f $INSTALCONF ]; then
		#no esta instalado
		echo false;
	else
		echo true;
	fi
}

verificarCompletitud(){
	local INSTALACION_CORRECTA=true
	
	if [ ! -f $grupo/$CONFDIR/T1.tab ] ; then
		INSTALACION_CORRECTA=false
	fi
	
	if [ ! -f  $grupo/$CONFDIR/T2.tab ] ; then
		INSTALACION_CORRECTA=false
	fi
	
	if [ ! -f $grupo/$MAEDIR/p-s.mae ] ; then
		INSTALACION_CORRECTA=false
	fi
	
	if [ ! -f $grupo/$MAEDIR/PPI.mae ] ; then
		INSTALACION_CORRECTA=false
	fi
	
	if [ ! -f $grupo/$BINDIR/checkVersion.pl ] ; then
		INSTALACION_CORRECTA=false
	fi
	
	if [ ! -f $grupo/$BINDIR/Detecta4.sh ] ; then
		INSTALACION_CORRECTA=false
	fi
	
	if [ ! -f $grupo/$BINDIR/Glog4.sh ] ; then
		INSTALACION_CORRECTA=false
	fi
	
	if [ ! -f $grupo/$BINDIR/Inicio4.sh ] ; then
		INSTALACION_CORRECTA=false
	fi
	
	if [ ! -f $grupo/$BINDIR/Interprete.sh ] ; then
		INSTALACION_CORRECTA=false
	fi
	
	if [ ! -f $grupo/$BINDIR/Mov4.sh ] ; then
		INSTALACION_CORRECTA=false
	fi
	
	if [ ! -f $grupo/$BINDIR/Reporte4.pl ] ; then
		INSTALACION_CORRECTA=false
	fi
	
	if [ ! -f $grupo/$BINDIR/Vlog4.sh ] ; then
		INSTALACION_CORRECTA=false
	fi
	
	echo $INSTALACION_CORRECTA
}

obtenerFaltantes(){
	local FALTANTES
	if [ ! -f $grupo/$CONFDIR/T1.tab ] ; then
		logear Falta Archivo: $grupo/$CONFDIR/T1.tab
		FALTANTES="$FALTANTES $archivos/T1.tab"
	fi
	
	if [ ! -f  $grupo/$CONFDIR/T2.tab ] ; then
		logear Falta Archivo: $grupo/$CONFDIR/T2.tab
		FALTANTES="$FALTANTES $archivos/T2.tab"
	fi
	
	if [ ! -f $grupo/$MAEDIR/p-s.mae ] ; then
		logear Falta Archivo: $grupo/$MAEDIR/p-s.mae
		FALTANTES="$FALTANTES $archivos/maestros/p-s.mae"
	fi
	
	if [ ! -f $grupo/$MAEDIR/PPI.mae ] ; then
		logear Falta Archivo: $grupo/$MAEDIR/PPI.mae
		FALTANTES="$FALTANTES $archivos/maestros/PPI.mae"
	fi
	
	if [ ! -f $grupo/$BINDIR/checkVersion.pl ] ; then
		logear Falta Archivo: $grupo/$BINDIR/checkVersion.pl
		FALTANTES="$FALTANTES $archivos/binarios/checkVersion.pl"
	fi
	
	if [ ! -f $grupo/$BINDIR/Detecta4.sh ] ; then
		logear Falta Archivo: $grupo/$BINDIR/Detecta4.sh
		FALTANTES="$FALTANTES $archivos/binarios/Detecta4.sh"
	fi
	
	if [ ! -f $grupo/$BINDIR/Glog4.sh ] ; then
		logear Falta Archivo: $grupo/$BINDIR/Glog4.sh
		FALTANTES="$FALTANTES $archivos/binarios/Glog4.sh"
	fi
	
	if [ ! -f $grupo/$BINDIR/Inicio4.sh ] ; then
		logear Falta Archivo: $grupo/$BINDIR/Inicio4.sh
		FALTANTES="$FALTANTES $archivos/binarios/Inicio4.sh"
	fi
	
	if [ ! -f $grupo/$BINDIR/Interprete.sh ] ; then
		logear Falta Archivo: $grupo/$BINDIR/Interprete.sh
		FALTANTES="$FALTANTES $archivos/binarios/Interprete.sh"
	fi
	
	if [ ! -f $grupo/$BINDIR/Mov4.sh ] ; then
		logear Falta Archivo: $grupo/$BINDIR/Mov4.sh
		FALTANTES="$FALTANTES $archivos/binarios/Mov4.sh"
	fi
	
	if [ ! -f $grupo/$BINDIR/Reporte4.pl ] ; then
		logear Falta Archivo: $grupo/$BINDIR/Reporte4.pl
		FALTANTES="$FALTANTES $archivos/binarios/Reporte4.pl"
	fi
	
	if [ ! -f $grupo/$BINDIR/Vlog4.sh ] ; then
		logear Falta Archivo: $grupo/$BINDIR/Vlog4.sh
		FALTANTES="$FALTANTES $archivos/binarios/Vlog4.sh"
	fi
	
	
	
	echo $FALTANTES
	
}

extraerVariablesDeInstalacion(){

	local cont=0
	#extraemos el dir de instalacion
	read base < $INSTALCONF
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
	done < $INSTALCONF
	
	
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

printCompleto(){	
	printResumenDatosLevantados
	logearResumenDatos
	logear "Estado de la instalacion: COMPLETA"
	echo "Estado de la instalacion: COMPLETA"
}

printIncompleto(){
	printResumenDatosLevantados
	logearResumenDatos
	echo "Componentes faltantes: $FALTANTES
Estado de la instalación: INCOMPLETA"
	logearIncompleto

}

logearIncompleto(){
	
logear Componentes faltantes: $FALTANTES
logear Estado de la instalación: INCOMPLETA
}


verificarPerl(){
	local versionPerl=$(perl checkVersion.pl)
	local mensajeError="Para instalar el TP es necesario tener Perl 5 o superior instalado. 
		Efectúe su instalación e intentelo nuevamente."
	if [ $versionPerl = ERROR ]; then
		logear $mensajeError
		logear "Proceso de instalación cancelado"
		echo $mensajeError
		echo "Proceso de instalación cancelado"
	else
		echo "Perl Version: " $versionPerl
		logear "Perl Version: " $versionPerl
	fi
}

definirDirectorioInstalacion(){
	
	echo "Directorio de instalación de los ejecutables: $grupo/$BINDIR. "
	echo "Desea cambiarlo? (si / no)"
	local leido
	read -s flag
	while [ "$flag" != si ] && [ "$flag" != Si ] && [ "$flag" != no ] && [ "$flag" != No ] && [ "$flag" != SI ] && [ "$flag" != NO ] && [ "$flag" != "" ]; do 
        echo "Por favor, ingrese una opción correcta"
		read -s flag
	done
	
	if [ "$flag" = si ] || [ "$flag" = Si ] || [ "$flag" = SI ] || [ "$flag" = "" ]; then
		echo "Ingrese el nuevo directorio de instalación de ejecutables"
		read leido
		logear "Directorio de instalación de ejecutables: "$grupo/$leido
		echo "Directorio de instalación de ejecutables: "$grupo/$leido
		BINDIR=$leido
	else
		logear "Directorio de instalación de ejecutables: $grupo/$BINDIR" 
		echo "Directorio de instalación de ejecutables: $grupo/$BINDIR"
	fi
}


definirDirectorioArchivosMaestros(){
	
	echo "Directorio de instalación de los archivos maestros: $grupo/$MAEDIR. "
	echo "Desea cambiarlo? (si / no)"
	local leido
	read -s flag
	while [ "$flag" != si ] && [ "$flag" != Si ] && [ "$flag" != no ] && [ "$flag" != No ] && [ "$flag" != SI ] && [ "$flag" != NO ] && [ "$flag" != "" ]; do 
        echo "Por favor, ingrese una opción correcta"
		read -s flag
	done
	
	if [ "$flag" = si ] || [ "$flag" = Si ] || [ "$flag" = SI ] || [ "$flag" = "" ]; then
		echo "Ingrese el nuevo directorio de instalación de los archivos maestros"
		read leido
		logear "Directorio de instalación de los archivos maestros: "$grupo/$leido
		echo "Directorio de instalación de los archivos maestros: "$grupo/$leido
		MAEDIR=$leido
	else
		logear "Directorio de instalación de los archivos maestros: $grupo/$MAEDIR" 
		echo "Directorio de instalación de los archivos maestros: $grupo/$MAEDIR"
	fi
}




definirDirectorioArriboArchivosExternos(){
	
	echo "Directorio de arribo de los archivos externos: $grupo/$ARRIDIR. "
	echo "Desea cambiarlo? (si / no)"
	local leido
	read -s flag
	while [ "$flag" != si ] && [ "$flag" != Si ] && [ "$flag" != no ] && [ "$flag" != No ] && [ "$flag" != SI ] && [ "$flag" != NO ] && [ "$flag" != "" ]; do 
        echo "Por favor, ingrese una opción correcta"
		read -s flag
	done
	
	if [ "$flag" = si ] || [ "$flag" = Si ] || [ "$flag" = SI ] || [ "$flag" = "" ]; then
		echo "Ingrese el nuevo directorio de instalación de los archivos externos"
		read leido
		logear "Directorio de instalación de los archivos externos: "$grupo/$leido
		echo "Directorio de instalación de los archivos externos: "$grupo/$leido
		ARRIDIR=$leido
	else
		logear "Directorio de instalación de los archivos externos: $grupo/$ARRIDIR" 
		echo "Directorio de instalación de los archivos externos: $grupo/$ARRIDIR"
	fi
}

definirEspacioLibre(){
	
	echo "Espacio mínimo libre para el arribo de archivos externos (Mb): $DATASIZE"
	echo "Desea cambiarlo? (si / no)"
	local leido
	read -s flag
	while [ "$flag" != si ] && [ "$flag" != Si ] && [ "$flag" != no ] && [ "$flag" != No ] && [ "$flag" != SI ] && [ "$flag" != NO ] && [ "$flag" != "" ]; do 
        echo "Por favor, ingrese una opción correcta"
		read -s flag
	done
	
	if [ "$flag" = si ] || [ "$flag" = Si ] || [ "$flag" = SI ] || [ "$flag" = "" ]; then
		echo "Ingrese el nuevo Espacio mínimo libre para el arribo de archivos externos"
		read leido
		#checkeamos que sea un numero
		while ! [[ "$leido" =~ [0-9]+$ ]]; do
			echo "Por favor, ingrese un número válido"
			read leido	
		done
		
		logear "Espacio mínimo libre para el arribo de archivos externos (Mb): "$leido
		echo "Espacio mínimo libre para el arribo de archivos externos (Mb): "$leido
		DATASIZE=$leido
	else
		logear "Espacio mínimo libre para el arribo de archivos externos (Mb): $DATASIZE" 
		echo "Espacio mínimo libre para el arribo de archivos externos (Mb): $DATASIZE"
	fi
}

verificarEspacioLibre(){
	local aux=$(df -m . | awk 'NR==2 {print $4}')
	while [ $DATASIZE -ge $aux ];do
		logear "Insuficiente espacio en disco."
		logear "Espacio disponible: " $aux " Mb."
		logear "Espacio requerido: " $DATASIZE " Mb."
        logear "Cancele la instalación e inténtelo mas tarde o vuelva a intentarlo otro valor."
       	echo "Insuficiente espacio en disco.
Espacio disponible: $aux Mb. 
Espacio requerido $DATASIZE Mb
Cancele la instalación e inténtelo mas tarde o vuelva a intentarlo
con otro valor."
	definirEspacioLibre
	done

}


definirDirectorioArchivosRechazados(){
	
	echo "Directorio de grabación de los archivos externos rechazados: $grupo/$RECHDIR. "
	echo "Desea cambiarlo? (si / no)"
	local leido
	read -s flag
	while [ "$flag" != si ] && [ "$flag" != Si ] && [ "$flag" != no ] && [ "$flag" != No ] && [ "$flag" != SI ] && [ "$flag" != NO ] && [ "$flag" != "" ]; do 
        echo "Por favor, ingrese una opción correcta"
		read -s flag
	done
	
	if [ "$flag" = si ] || [ "$flag" = Si ] || [ "$flag" = SI ] || [ "$flag" = "" ]; then
		echo "Ingrese el nuevo directorio de grabación de los archivos externos rechazados"
		read leido
		logear "Directorio de grabación de los archivos externos rechazados: "$grupo/$leido
		echo "Directorio de grabación de los archivos externos rechazados: "$grupo/$leido
		RECHDIR=$leido
	else
		logear "Directorio de grabación de los archivos externos rechazados: $grupo/$RECHDIR" 
		echo "Directorio de grabación de los archivos externos rechazados: $grupo/$RECHDIR"
	fi
}


definirDirectorioArchivosAceptados(){
	
	echo "Directorio de grabación de los archivos externos aceptados: $grupo/$ACEPDIR. "
	echo "Desea cambiarlo? (si / no)"
	local leido
	read -s flag
	while [ "$flag" != si ] && [ "$flag" != Si ] && [ "$flag" != no ] && [ "$flag" != No ] && [ "$flag" != SI ] && [ "$flag" != NO ] && [ "$flag" != "" ]; do 
        echo "Por favor, ingrese una opción correcta"
		read -s flag
	done
	
	if [ "$flag" = si ] || [ "$flag" = Si ] || [ "$flag" = SI ] || [ "$flag" = "" ]; then
		echo "Ingrese el nuevo directorio de grabación de los archivos externos aceptados"
		read leido
		logear "Directorio de grabación de los archivos externos aceptados: "$grupo/$leido
		echo "Directorio de grabación de los archivos externos aceptados: "$grupo/$leido
		ACEPDIR=$leido
	else
		logear "Directorio de grabación de los archivos externos aceptados: $grupo/$ACEPDIR" 
		echo "Directorio de grabación de los archivos externos aceptados: $grupo/$ACEPDIR"
	fi
}


definirDirectorioArchivosProcesados(){
	
	echo "Directorio de grabación de los archivos externos procesados: $grupo/$PROCDIR. "
	echo "Desea cambiarlo? (si / no)"
	local leido
	read -s flag
	while [ "$flag" != si ] && [ "$flag" != Si ] && [ "$flag" != no ] && [ "$flag" != No ] && [ "$flag" != SI ] && [ "$flag" != NO ] && [ "$flag" != "" ]; do 
        echo "Por favor, ingrese una opción correcta"
		read -s flag
	done
	
	if [ "$flag" = si ] || [ "$flag" = Si ] || [ "$flag" = SI ] || [ "$flag" = "" ]; then
		echo "Ingrese el nuevo directorio de grabación de los archivos procesados"
		read leido
		logear "Directorio de grabación de los archivos procesados: "$grupo/$leido
		echo "Directorio de grabación de los archivos procesados: "$grupo/$leido
		PROCDIR=$leido
	else
		logear "Directorio de grabación de los archivos procesados: $grupo/$PROCDIR" 
		echo "Directorio de grabación de los archivos procesados: $grupo/$PROCDIR"
	fi
}

definirDirectorioReportesSalida(){
	
	echo "Directorio de grabación de los reportes de salida: $grupo/$REPODIR. "
	echo "Desea cambiarlo? (si / no)"
	local leido
	read -s flag
	while [ "$flag" != si ] && [ "$flag" != Si ] && [ "$flag" != no ] && [ "$flag" != No ] && [ "$flag" != SI ] && [ "$flag" != NO ] && [ "$flag" != "" ]; do 
        echo "Por favor, ingrese una opción correcta"
		read -s flag
	done
	
	if [ "$flag" = si ] || [ "$flag" = Si ] || [ "$flag" = SI ] || [ "$flag" = "" ]; then
		echo "Ingrese el nuevo directorio de grabación de los reportes de salida"
		read leido
		logear "Directorio de grabación de los reportes de salida: "$grupo/$leido
		echo "Directorio de grabación de los reportes de salida: "$grupo/$leido
		REPODIR=$leido
	else
		logear "Directorio de grabación de los reportes de salida: $grupo/$REPODIR" 
		echo "Directorio de grabación de los reportes de salidas: $grupo/$REPODIR"
	fi
}


definirDirectorioLogs(){
	
	echo "Directorio de grabación de logs: $grupo/$LOGDIR. "
	echo "Desea cambiarlo? (si / no)"
	local leido
	read -s flag
	while [ "$flag" != si ] && [ "$flag" != Si ] && [ "$flag" != no ] && [ "$flag" != No ] && [ "$flag" != SI ] && [ "$flag" != NO ] && [ "$flag" != "" ]; do 
echo "Por favor, ingrese una opción correcta"
		read -s flag
	done
	
	if [ "$flag" = si ] || [ "$flag" = Si ] || [ "$flag" = SI ] || [ "$flag" = "" ]; then
		echo "Ingrese el nuevo directorio de logs"
		read leido
		logear "Directorio de grabación de logs: "$grupo/$leido
		echo "Directorio de grabación de logs: "$grupo/$leido
		LOGDIR=$leido
	else
		logear "Directorio de grabación de logs: $grupo/$LOGDIR" 
		echo "Directorio de grabación de logs: $grupo/$LOGDIR"
	fi
}

definirExtensionLogs(){
	
	echo "Extensión para archivos de log: $LOGEXT. "
	echo "Desea cambiarla? (si / no)"
	local leido
	read -s flag
	while [ "$flag" != si ] && [ "$flag" != Si ] && [ "$flag" != no ] && [ "$flag" != No ] && [ "$flag" != SI ] && [ "$flag" != NO ] && [ "$flag" != "" ]; do 
       echo "Por favor, ingrese una opción correcta"
		read -s flag
	done
	
	if [ "$flag" = si ] || [ "$flag" = Si ] || [ "$flag" = SI ] || [ "$flag" = "" ]; then
		echo "Ingrese la nueva extensión para archivos de log"
		read leido
		#checkeamos que sea una extension
		while ! [[ "$leido" =~ [.*] ]]; do
			echo "Por favor, ingrese una extensión que empiece con \".\""
			read -s leido	
		done
		logear "Extensión para archivos de log: "$leido
		echo "Extensión para archivos de log: "$leido
		LOGEXT=$leido
	else
		logear "Extensión para archivos de log: $LOGEXT" 
		echo "Extensión para archivos de log: $LOGEXT"
	fi
}

definirTamañoLogs(){
	
	echo "Tamaño para archivos de log (Kb): $LOGSIZE "
	echo "Desea cambiarla? (si / no)"
	local leido
	read -s flag
	while [ "$flag" != si ] && [ "$flag" != Si ] && [ "$flag" != no ] && [ "$flag" != No ] && [ "$flag" != SI ] && [ "$flag" != NO ] && [ "$flag" != "" ]; do 
        echo "Por favor, ingrese una opción correcta"
		read -s flag
	done
	
	if [ "$flag" = si ] || [ "$flag" = Si ] || [ "$flag" = SI ] || [ "$flag" = "" ]; then
		echo "Ingrese un nuevo tamaño para archivos de log (Kb)"
		read leido
		#checkeamos que sea un numero
		while ! [[ "$leido" =~ [0-9]+$ ]]; do
			echo "Por favor, ingrese un número válido"
			read leido	
		done
		logear "Tamaño para archivos de log: "$leido
		echo "Tamaño para archivos de log: "$leido
		LOGSIZE=$leido
	else
		logear "Tamaño para archivos de log (Kb): $LOGSIZE" 
		echo "Tamaño para archivos de log (Kb): $LOGSIZE"
	fi
}

clrscr(){
	printf "\033c"
}

printResumenDatosLevantados(){
local grupo=$(pwd)/$grupo
	echo "TP SO7508 Primer Cuatrimestre 2013. Tema Y Copyright © Grupo xx
Librería del Sistema: $grupo/$CONFDIR
Ejecutables: $grupo/$BINDIR 
Archivos maestros: $grupo/$MAEDIR
Directorio de arribo de archivos externos: $grupo/$ARRIDIR
Espacio mínimo libre para arribos: $DATASIZE Mb
Archivos externos aceptados: $grupo/$ACEPDIR
Archivos externos rechazados: $grupo/$RECHDIR
Archivos procesados: $grupo/$PROCDIR
Reportes de salida: $grupo/$REPODIR
Logs de auditoria del Sistema: $grupo/$LOGDIR/<comando>$LOGEXT
Tamaño máximo para los archivos de log del sistema: $LOGSIZE Kb"
}



logearResumenDatos(){
	local grupo=$(pwd)/$grupo
	logear TP SO7508 Primer Cuatrimestre 2013. Tema Y Copyright © Grupo xx
	logear Librería del Sistema: $grupo/$CONFDIR
	logear Ejecutables: $grupo/$BINDIR 
	logear Archivos maestros: $grupo/$MAEDIR
	logear Directorio de arribo de archivos externos: $grupo/$ARRIDIR
	logear Espacio mínimo libre para arribos: $DATASIZE Mb
	logear Archivos externos aceptados: $grupo/$ACEPDIR
	logear Archivos externos rechazados: $grupo/$RECHDIR
	logear Archivos procesados: $grupo/$PROCDIR
	logear Reportes de salida: $grupo/$REPODIR
	logear Logs de auditoria del Sistema: $grupo/$LOGDIR/"<comando>"$LOGEXT
	logear Tamaño máximo para los archivos de log del sistema: $LOGSIZE Kb
}

pedirDatos(){
	definirDirectorioInstalacion
	definirDirectorioArchivosMaestros
	definirDirectorioArriboArchivosExternos
	definirEspacioLibre
	verificarEspacioLibre
	definirDirectorioArchivosRechazados
	definirDirectorioArchivosAceptados
	definirDirectorioArchivosProcesados
	definirDirectorioReportesSalida
	definirDirectorioLogs
	definirExtensionLogs
	clrscr
}


crearDirectorios(){
	echo "Creando Estructuras de directorio. . . ."
	mkdir -p $grupo/$BINDIR 2>/dev/null
	echo $grupo/$BINDIR
	mkdir -p $grupo/$MAEDIR 2>/dev/null
	echo $grupo/$MAEDIR
	mkdir -p $grupo/$ARRIDIR 2>/dev/null
	echo $grupo/$ARRIDIR
	mkdir -p $grupo/$RECHDIR 2>/dev/null
	echo $grupo/$RECHDIR
	mkdir -p $grupo/$ACEPDIR 2>/dev/null
	echo $grupo/$ACEPDIR
	mkdir -p $grupo/$PROCDIR 2>/dev/null
	echo $grupo/$PROCDIR
	mkdir -p $grupo/$LOGDIR 2>/dev/null
	echo $grupo/$LOGDIR
	mkdir -p $grupo/$REPODIR 2>/dev/null
	echo $grupo/$REPODIR

}

moverArchivos(){
	echo "Instalando Archivos Maestros"
	cp archivos/maestros/* $grupo/$MAEDIR 2>/dev/null
	echo Instalando Tablas de Configuración
	cp archivos/T*.tab $grupo/$CONFDIR 2>/dev/null
	echo Instalando Programas y Funciones
	cp archivos/ejecutables/* $grupo/$BINDIR 2>/dev/null
	echo Actualizando la configuración del sistema
	
}

actualizarConfiguracion(){
	local user=$(whoami)
	local fecha=$(date)
	echo "GRUPO"=$grupo=$user=$fecha >> $INSTALCONF
	echo "CONFDIR"=$CONFDIR=$user=$fecha >> $INSTALCONF
	echo "BINDIR"=$BINDIR=$user=$fecha >> $INSTALCONF
	echo "MAEDIR"=$MAEDIR=$user=$fecha >> $INSTALCONF
	echo "ARRIDIR"=$ARRIDIR=$user=$fecha >> $INSTALCONF
	echo "ACEPDIR"=$ACEPDIR=$user=$fecha >> $INSTALCONF
	echo "RECHDIR"=$RECHDIR=$user=$fecha >> $INSTALCONF
	echo "PROCDIR"=$PROCDIR=$user=$fecha >> $INSTALCONF
	echo "REPODIR"=$REPODIR=$user=$fecha >> $INSTALCONF
	echo "LOGDIR"=$LOGDIR=$user=$fecha >> $INSTALCONF
	echo "LOGEXT"=$LOGEXT=$user=$fecha >> $INSTALCONF
	echo "LOGSIZE"=$LOGSIZE=$user=$fecha >> $INSTALCONF
	echo "DATASIZE"=$DATASIZE=$user=$fecha >> $INSTALCONF
	
	
}

moveScriptFiles() {
	cp * $grupo/ 2>/dev/null
}

exportarVariablesDeAmbiente() {
	export CONFDIR
	export MAEDIR
	export BINDIR
	export ARRIDIR
	export DATASIZE
	export ACEPDIR
	export RECHDIR
	export PROCDIR
	export REPODIR
	export LOGEXT
	export LOGDIR
	export LOGSIZE
	export grupo
	
}


exportarVariablesDeAmbienteAlternativo() {
	echo "export" CONFDIR=$CONFDIR >> ~/.bashrc
	echo "export" MAEDIR=$MAEDIR >> ~/.bashrc
	echo "export" BINDIR=$BINDIR >> ~/.bashrc
	echo "export" ARRIDIR=$ARRIDIR >> ~/.bashrc
	echo "export" DATASIZE=$DATASIZE >> ~/.bashrc
	echo "export" ACEPDIR=$ACEPDIR >> ~/.bashrc
	echo "export" RECHDIR=$RECHDIR >> ~/.bashrc
	echo "export" PROCDIR=$PROCDIR >> ~/.bashrc
	echo "export" REPODIR=$REPODIR >> ~/.bashrc
	echo "export" LOGEXT=$LOGEXT >> ~/.bashrc
	echo "export" LOGDIR=$LOGDIR >> ~/.bashrc
	echo "export" LOGSIZE=$LOGSIZE >> ~/.bashrc
	echo "export" grupo=$(pwd)/$grupo >> ~/.bashrc
	
	. ~/.bashrc
	
}

printComponentesAInstalar(){

echo "Se instalaran los siguientes componentes nuevos: $FALTANTES"
	
}

cambiarADirectorioInstalacion () {
	cd $grupo
}

completarInstalacion(){
	
	echo "Desea completar la instalación? (Si-No)";
	read -s flag
	while [ "$flag" != si ] && [ "$flag" != Si ] && [ "$flag" != no ] && [ "$flag" != No ] && [ "$flag" != SI ] && [ "$flag" != NO ] && [ "$flag" != "" ]; do 
        echo "Por favor, ingrese una opción correcta"
		read -s flag
	done
	
	if [ "$flag" = si ] || [ "$flag" = Si ] || [ "$flag" = SI ] || [ "$flag" = "" ]; then
		verificarPerl
		printComponentesAInstalar
		printResumenDatosLevantados
		echo "Iniciando Instalación. Esta Ud. seguro? (si/no)"
		read -s confirmar
		while [ "$confirmar" != si ] && [ "$confirmar" != Si ] && [ "$confirmar" != no ] && [ "$confirmar" != No ] && [ "$confirmar" != SI ] && [ "$confirmar" != NO ] && [ "$confirmar" != "" ]; do 
			echo "Por favor, ingrese una opcion correcta (si/no)"
			read -s confirmar
		done
		if [ "$confirmar" = si ] || [ "$confirmar" = Si ] || [ "$confirmar" = SI ] || [ "$confirmar" = "" ]; then
			crearDirectorios
			moverArchivos
			actualizarConfiguracion
		fi
	fi
}

instalar(){
	echo "TP SO7508 Primer Cuatrimestre 2013. Tema Y Copyright © Grupo 04
A T E N C I O N: Al instalar TP SO7508 Primer Cuatrimestre 2013 usted 
expresa aceptar los términos y Condiciones del \"ACUERDO DE LICENCIA DE
SOFTWARE\" incluido en este paquete.
Acepta? Si – No";
	read -s flag
	while [ "$flag" != si ] && [ "$flag" != Si ] && [ "$flag" != no ] && [ "$flag" != No ] && [ "$flag" != SI ] && [ "$flag" != NO ] && [ "$flag" != "" ]; do 
        echo "Por favor, ingrese una opción correcta"
		read -s flag
	done
	
	if [ "$flag" = si ] || [ "$flag" = Si ] || [ "$flag" = SI ] || [ "$flag" = "" ]; then
		verificarPerl
		pedirDatos
		printResumenDatosLevantados
		echo "Son estos datos correctos? (si / no)"
		
		read -s pregunta
		while [ "$pregunta" != si ] && [ "$pregunta" != Si ] && [ "$pregunta" != no ] && [ "$pregunta" != No ] && [ "$pregunta" != SI ] && [ "$pregunta" != NO ] && [ "$pregunta" != "" ]; do 
			echo "Por favor, ingrese una opcion correcta (si/no)"
			read -s pregunta
		done
		while [ "$pregunta" = no ] || [ "$pregunta" = NO ] || [ "$pregunta" = No ]; do
			pedirDatos
			printResumenDatosLevantados
			echo "Estado de la instalacion: LISTA"
			echo "Son estos datos correctos? (Si/No)"
			read -s pregunta
		done
		
		echo "Iniciando Instalación. Esta Ud. seguro? (si/no)"
		read -s confirmar
		while [ "$confirmar" != si ] && [ "$confirmar" != Si ] && [ "$confirmar" != no ] && [ "$confirmar" != No ] && [ "$confirmar" != SI ] && [ "$confirmar" != NO ] && [ "$confirmar" != "" ]; do 
			echo "Por favor, ingrese una opcion correcta (si/no)"
			read -s confirmar
		done
		if [ "$confirmar" = si ] || [ "$confirmar" = Si ] || [ "$confirmar" = SI ] || [ "$confirmar" = "" ]; then
			crearDirectorios
			moverArchivos
			actualizarConfiguracion
			moveScriptFiles
		fi
	fi
	
}



inicializarLog
ESTA_INSTALADO=$(verificarInstalacion)
if  $ESTA_INSTALADO ; then
	extraerVariablesDeInstalacion
	ESTA_COMPLETO=$(verificarCompletitud)
	if [ $ESTA_COMPLETO == true ]; then
		printCompleto
	else
		FALTANTES=$(obtenerFaltantes)
		printIncompleto
		completarInstalacion
	fi
else
	instalar
fi
logear "Fin de Ejecución"

cambiarADirectorioInstalacion
#exportarVariablesDeAmbienteAlternativo
