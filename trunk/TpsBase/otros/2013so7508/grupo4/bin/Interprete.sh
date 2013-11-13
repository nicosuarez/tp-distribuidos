#!/bin/bash

#Entrada:
# Archivos Recibidos $ACEPDIR/<pais>-<sistema>-<año>-<mes>
# Tabla de Separadores $CONFDIR/T1.tab
# Tabla de Campos $CONFDIR/T2.tab
#Salida:
# Archivos de Préstamos Personales por país $PROCDIR/PRESTAMOS.<pais>
# Archivos (duplicados) Rechazados $RECHDIR/<nombre del archivo>
# Archivos Procesados $PROCDIR/<pais>-<sistema>-<año>-<mes>
# Log $LOGDIR/Interprete.$LOGEXT

#T1.tab
#campo1 Código de País  Tipo: carácter  Variable: PAIS_ID
#campo2 Código de Sistema Tipo:numérico  Variable: SIS_ID
#campo3 Carácter Separador de Campo Tipo: carácter  Variable: SEP_CAMP
#campo4 Carácter Separador de decimales Tipo: carácter  Variable: SEP_DEC

#T2.tab
#campo1 País
#campo2 Sistema
#campo3 Nombre del Campo
#campo 4 numero de orden Orden
#campo5 Formato

#~ Logeo inicio Del Interprete
REST=0
function logearInicioInterprete() {
	./Glog4.sh "Se inicializa el interprete con $CANTIDAD archivos" "MENSAJE" "Interprete"
}

#Debe recibir obligatoriamente 3 parametros
function cantidadParametros()
{
	if [ $1 -eq 3 ] ; then
		ACCEPDIR=$1
		T1=$2
		T2=$3
		return 0
	elif [ $1 -eq 0 ] ; then
		ACCEPDIR="$ACEPDIR"
		T1="$CONFDIR/T1.tab"
		T2="$CONFDIR/T2.tab"
		return 0
	else
		msj="Cantidad De parametros invalidos."
		echo $msj
		./Glog4.sh "$msj" "MENSAJE" "Interprete"
		return 1
fi
}
#calcula la cantidad de datos del input
function cantidadDeArchivosInput()
{
	echo $(ls -A $1 | wc -l)
}

function controlarArchivosObligatorios()
{
	if [ "$1" != "$CONFDIR/T1.tab" ] || [ "$2" != "$CONFDIR/T2.tab" ] ; then
	#Esto iria en el log
	echo "No pasa algun archivo de configuracion obligatorio"
	return 0
	else
		return 1
fi	
}

function devolverCodigoPaisT1()
{
	PAIS=$2
	SISTEMA=$3
	echo $(cat "$1" | fgrep "$PAIS" | fgrep "$SISTEMA"| cut -d "-" -f 1)
}
function devolverCodigoSistemaT1()
{
	PAIS=$2
	SISTEMA=$3
	echo $(cat "$1" | fgrep "$PAIS" | fgrep "$SISTEMA"| cut -d "-" -f 2)
}
function devolverCaracterSeparadorCampoT1()
{
	PAIS=$2
	SISTEMA=$3
	echo $(cat "$1" | fgrep "$PAIS" | fgrep "$SISTEMA"| cut -d "-" -f 3)
	
}
function devolverCaraterSeparadorDecimalT1()
{
	PAIS=$2
	SISTEMA=$3
	echo $(cat "$1"| fgrep "$PAIS" | fgrep "$SISTEMA"| cut -d "-" -f 4|cut -c 1)
}
function devolverCodigoPaisT2()
{
	echo $(echo "$1" | cut -d "-" -f 1)
}
function devolverCodigoSistemaT2()
{
	echo $(echo "$1" | cut -d "-" -f 2)
}
function devolverNombreCampoT2()
{
	echo $(echo "$1" | cut -d "-" -f 3)
}
function devolverNumeroOrdenT2()
{
	echo $(echo "$1" | cut -d "-" -f 4) 
}
function devolverFormatoT2()
{
	echo $(echo "$1" | cut -d "-" -f 5) 
}
function devolverCampo()
{
		cat $1 | cut -d "$2" -f $3
}

#recibe campo a parsear, separador numerico de archivo y separador que tengo q poner
function traducirNumerico()
{
		#ENTERO=$(echo "$1" | cut -d "$2" -f 1)
		#DECIMAL=$(echo "$1" | cut -d "$2" -f 2)
		#ENTERO=$(echo "$1" | grep ".*$2")
		#DECIMAL=$(echo "$1" | grep "$2.*")
		#if [ "$ENTERO" == "" ] ; then 

		#	ENTERO="0"
		#elif  [ "$DECIMAL" == "" ] ; then
		#	DECIMAL="0"
		#fi	
		#NUMERO="$ENTERO,$DECIMAL"
		#echo $NUMERO
		#msj="me viene $1 y $2"
		#./Glog4.sh "$msj" "MENSAJE" "Interprete" 
		if [ "$1" = "$2"  ]; then
			msj="Campo numerico vacio. Se reemplaza por 0,0"
			./Glog4.sh "$msj" "MENSAJE" "Interprete" 
			echo "0,0"
		else
			if [ "$2" = "."  ]; then					
				NUMERO=`echo "$1" | sed 's/\./,/'`	
				#msj="devuelvo $NUMERO"
				#./Glog4.sh "$msj" "MENSAJE" "Interprete" 
			else
				
				NUMERO=`echo "$1" | sed "s/$2/,/"`		
				#msj="entro al sino y devuelvo $NUMERO"
				#./Glog4.sh "$msj" "MENSAJE" "Interprete" 
			fi	
			echo $NUMERO
		fi	
}
#esta funcion recibe el nombre $1 y el campo sin modificar $2 el formato $3 y el separadorDecimal $4
function traducirCampo()
{
	
	cadena=$2
	case $1 in
	"CTB_FE" )
		fecha=$3
		FECHA=${fecha:0:6}
		LONGITUD=${fecha:6:3}
		LONGITUD=`echo "$LONGITUD" | cut -d "." -f1`
		TRADUCIDO=$(traducirFecha $cadena $FECHA $LONGITUD )
		echo $TRADUCIDO
	;;
	"MT_IMPAGO" )
		TRADUCIDO=$(traducirNumerico $cadena $4 $SEPARADORDECIMAL)
		#REST=`expr $REST+$TRADUCIDO`
		
		echo $TRADUCIDO
	;;	
	"MT_PRES" )
		TRADUCIDO=$(traducirNumerico $cadena $4 $SEPARADORDECIMAL)
		#REST=`expr $REST+$TRADUCIDO`
		echo $TRADUCIDO
	;;
	"MT_DEB" )
		TRADUCIDO=$(traducirNumerico $cadena $4 $SEPARADORDECIMAL)
		#REST=`expr $REST-$TRADUCIDO`
		NUMERO=`echo "$TRADUCIDO"| sed 's/,/./'`
		echo $TRADUCIDO
	;;
	"MT_INDE" )
		TRADUCIDO=$(traducirNumerico $cadena $4 $SEPARADORDECIMAL)
		echo $TRADUCIDO
	;;
	"MT_INNODE" )
		TRADUCIDO=$(traducirNumerico $cadena $4 $SEPARADORDECIMAL)
		echo $TRADUCIDO
	;;
	* )
		echo $cadena
	esac
}

#Esta funcion recibe como $1 la fecha en el codigo sin traducir el tipo de fecha $2 y la longitud $3
function traducirFecha()
{
	fecha=$1	
	case $2 in
  "ddmmyy" )
  	if [ $3 -eq 8 ]; then
		DIA=${fecha:0:2}
		MES=${fecha:2:2}
		ANIO=${fecha:4:4}
		#hay q poner el año en 3 digitos
		echo "$DIA/$MES/$ANIO"
	elif [ $3 -eq 10 ]; then
		DIA=${fecha:0:2}
		MES=${fecha:3:2}
		ANIO=${fecha:6:4}
		#hay q poner el año en 3 digitos
		echo "$DIA/$MES/$ANIO"
	else
			#loguear que no se conoce la fecha
			echo "No se reconoce la fecha"
	fi	
	;;
	"yymmdd" )
		if [ $3 -eq 8 ]; then
			DIA=${fecha:6:2}
			MES=${fecha:4:2}
			ANIO=${fecha:0:4}
			#hay q poner el año en 3 digitos
			echo "$DIA/$MES/$ANIO"
		elif [ $3 -eq 10 ]; then
			DIA=${fecha:8:2}
			MES=${fecha:5:2}
			ANIO=${fecha:0:4}
			#hay q poner el año en 3 digitos
			echo "$DIA/$MES/$ANIO"
		else
			#loguear que no se conoce la fecha
			echo "No se reconoce la fecha"
		fi	
	;;
 esac
}
#controlo que si o si vengan 3 parametros sino salgo
#if  cantidadParametros $#  ; then
#	exit
#fi
	
ACCEPDIR="$ACEPDIR"
T1="$CONFDIR/T1.tab"
T2="$CONFDIR/T2.tab"
if [ -z "$ACCEPDIR" ]; then
	msj="No se encuentra la variable ACCEPDIR por lo tanto no se puede ejecutar el interprete"
	echo $msj
	./Glog4.sh "$msj" "ERROR" "Interprete"
	exit
fi	
#echo $ACCEPDIR
CANTIDAD=$(cantidadDeArchivosInput $ACCEPDIR)
msj="Se inicializa el interprete con $CANTIDAD archivos."
echo $msj
./Glog4.sh "$msj" "MENSAJE" "Interprete"

#controlo que me pasen los archivos T1 y T2 que necesito. Sino salgo
#if  controlarArchivosObligatorios $T1 $T2  ; then
#	exit
#fi
#Almacenamos el valor original de la variable IFS
oldIFS=$IFS

for i in $(ls $ACCEPDIR); do
	echo "$i"
	var="0"
	if [ -f "$PROCDIR/$i" ]; then
		#loguear que esta duplicado
			msj="Interprete Encontro un archivo duplicado"
			echo $msj
			./Glog4.sh "$msj" "ERROR" "Interprete"
			./Mov4.sh "$ACCEPDIR/$i" "$RECHDIR/$i"
	else	
			
		PAIS=`echo "$i" |cut -d "-" -f 1`
		SISTEMA=`echo "$i" | cut -d "-" -f 2`

		ANIO=`echo "$i" | cut -d "-" -f 3`

		MES=`echo "$i" | cut -d "-" -f 4`


		SEPARADORCAMPO=$(devolverCaracterSeparadorCampoT1 $T1 $PAIS $SISTEMA)
		#echo "separador de campo $SEPARADORCAMPO"
		if [ -z "$SEPARADORCAMPO" ]; then
			msj="Interprete no encuentra un formato valido para $i por lo tanto lo mueve a rechazados"
			#echo $msj
			./Glog4.sh "$msj" "ERROR" "Interprete"
			./Mov4.sh "$ACCEPDIR/$i" "$RECHDIR/$i"
			continue
		else
			msj="Se procedera a procesar $i"
			./Glog4.sh "$msj" "MENSAJE" "Interprete"
			SEPARADORDECIMAL=$(devolverCaraterSeparadorDecimalT1 $T1 $PAIS $SISTEMA)
		#	echo "separador decimal $SEPARADORDECIMAL"
			CAMPOAESCRIBIR=""
			SEPARADORCAMPOORIGINAL=";"

			#echo "cantidad de datos inicial ${#ARRAYNOMBRE[*]}"
		
			#Traigo de T2 todos los datos necesario y los guardo en 2 arrays con posicion y nombre
			for x in `cat "$T2" | fgrep "$PAIS-$SISTEMA"`;do
				NOMBRECAMPO=$(devolverNombreCampoT2 $x)
				ORDENCAMPO=$(devolverNumeroOrdenT2 $x)
				FORMATO=$(devolverFormatoT2 $x)
				ARRAYFORMATO[$ORDENCAMPO]=$FORMATO
				ARRAYNOMBRE[$ORDENCAMPO]=$NOMBRECAMPO
			done
		
			IFS=$'\n'
		
		
			for linea in `cat "$ACCEPDIR/$i"`;do
				linea=`echo "$linea"|sed "s/\\r//"`
				declare -A arrayAEscribir
				CANTIDADDEDATOS=${#ARRAYNOMBRE[@]}
				#cantAux=`echo "$linea" | awk 'BEGIN{FS="[$SEPARADORCAMPO]"} {print NR}'`
				cantAux=`echo "$linea" | awk -F"$SEPARADORCAMPO" "{ print NF }" `
				
				#echo "cantidad en T2 $CANTIDADDEDATOS --  cantidad separada $cantAux" 
				
				if [ "$CANTIDADDEDATOS" = "$cantAux" ];then
					for cantCampos in $(seq 1 1 $CANTIDADDEDATOS);do
						CAMPO=$(echo "$linea"| cut -d "$SEPARADORCAMPO" -f $cantCampos)
						NOMBRECAMPOACTUAL=${ARRAYNOMBRE[$cantCampos]}
						FORMATOCAMPOACTUAL=${ARRAYFORMATO[$cantCampos]}
						#echo "voy a traducir $NOMBRECAMPOACTUAL ---  $CAMPO -- con separador $SEPARADORDECIMAL"
						CAMPOTRADUCIDO=$(traducirCampo "$NOMBRECAMPOACTUAL" "$CAMPO" "$FORMATOCAMPOACTUAL" "$SEPARADORDECIMAL")
						arrayAEscribir[$NOMBRECAMPOACTUAL]=$CAMPOTRADUCIDO
					done
					MTREST=0
					SISID=$SISTEMA
					FECHA=${arrayAEscribir[CTB_FE]}
					unset arrayAEscribir["CTB_FE"]
					DIA=${FECHA:0:2}
					MES=${FECHA:3:2}
					ANIO=${FECHA:6:4}
					ESTADO=${arrayAEscribir[CTB_ESTADO]}
					unset arrayAEscribir["CTB_ESTADO"]
					PRESID=${arrayAEscribir[PRES_ID]}
					unset arrayAEscribir["PRES_ID"]
					MTPRES=${arrayAEscribir[MT_PRES]}
					unset arrayAEscribir["MT_PRES"]
					MTIMPAGO=${arrayAEscribir[MT_IMPAGO]}
					unset arrayAEscribir["MT_IMPAGO"]
					MTINDE=${arrayAEscribir[MT_INDE]}
					unset arrayAEscribir["MT_INDE"]
					MTINNODE=${arrayAEscribir[MT_INNODE]}
					unset arrayAEscribir["MT_INNODE"]
					MTDEB=${arrayAEscribir[MT_DEB]}
					unset arrayAEscribir["MT_DEB"]
					NUMERO1=`echo "$MTPRES" | sed 's/,/./'`
					NUMERO2=`echo "$MTIMPAGO"| sed 's/,/./'`
					NUMERO3=`echo "$MTINDE"| sed 's/,/./'`
					NUMERO4=`echo "$MTINNODE"| sed 's/,/./'`
					NUMERO5=`echo "$MTDEB"| sed 's/,/./'`
					MTREST=`echo "$NUMERO1+$NUMERO2+$NUMERO3+$NUMERO4-$NUMERO5"| bc | awk '{printf "%0.2f\n", $0}'`
					if [ "$MTREST" "<" "0" ];then
						msj="MT_REST es negativo en $i en $linea"
						./Glog4.sh "$msj" "MENSAJE" "Interprete"
						MTREST=`echo "0"`
					fi	
					MTREST=`echo "$MTREST" | sed "s/\./,/"`
					PRESCLIID=${arrayAEscribir[PRES_CLI_ID]}
					unset arrayAEscribir["PRES_CLI_ID"]
					PRESCLI=${arrayAEscribir[PRES_CLI]}
					unset arrayAEscribir["PRES_CLI"]
					INSFE=`date +%d/%m/%Y`
					INUSER=$USER
					CAMPOAESCRIBIR="$SISID;$ANIO;$MES;$DIA;$ESTADO;$PRESID;$MTPRES;$MTIMPAGO;$MTINDE;$MTINNODE;$MTDEB;$MTREST;$PRESCLIID;$PRESCLI;$INSFE;$INUSER"
					FILE="$PROCDIR/PRESTAMOS.$PAIS"
					`echo "$CAMPOAESCRIBIR" >> $FILE`
					for elemento in "${!arrayAEscribir[@]}" ;do
						msj="Campo $elemento desconocido en $i "
						#echo $msj
						./Glog4.sh "$msj" "ERROR" "Interprete"
						unset arrayAEscribir["$elemento"]
					done
					
				else
					
					msj="Error de delimitador de campo en $i "
					#echo $msj
					./Glog4.sh "$msj" "ERROR" "Interprete"
					var="1"
					break
				fi
			done 
			if [ "$var" = "1" ]; then
				msj="$i se envia a rechazados  $FILE"
				./Glog4.sh "$msj" "MENSAJE" "Interprete"
				./Mov4.sh "$ACCEPDIR/$i" "$RECHDIR/$i"
			else
				msj="$i se proceso con exito guardando los datos correspondientes en $FILE"
				./Glog4.sh "$msj" "MENSAJE" "Interprete"
				./Mov4.sh "$ACCEPDIR/$i" "$PROCDIR/$i"
			fi	
			unset ARRAYFORMATO
			unset ARRAYNOMBRE
			IFS=$oldIFS
		fi	
	fi
done	

msj="Finaliza  el interprete"
echo $msj
./Glog4.sh "$msj" "MENSAJE" "Interprete"



#logearInicioInterprete

