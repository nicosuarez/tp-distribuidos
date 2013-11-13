===== Instrucciones de Instalación =====

El script Instal4.sh instalará el sistema en su computadora. Debe ser
ejecutado desde el directorio en el que se encuentra el script de la
siguiente manera:
. Instal4.sh

Se necesita correr como '. Instal4.sh' y no como './Instal4.sh' puesto
que el script registra ciertas variables en el entorno de ejecución, y
de ser ejecutado en un subentorno del actual (con './Instal4.sh' esas
variables de ambiente se perderían y no sería posible continuar con
los demás scripts del sistema.

Parámetros: 1 (opcional): directorio donde se realizará la instalación

===== Instrucciones de Inicio del entorno =====

El script Inicio4.sh inicializará el entorno de su computadora, preparándolo
para que los scripts que componen a este sistema funciones de la manera en
la que fue pensado el mismo.

El script no recibe parámetros, la única entrada que recibe por parte del
usuario es, durante la ejecución del mismo, el tiempo de espera (TESPERA)
entre ciclos que esperará el script Detecta4.sh y la cantidad de ciclos
(CANLOOP) que realizará el demonio antes de detener su ejecución. El script
Inicio4.sh ofrece la posibilidad de comenzar la ejecución del demonio.

Este script es el encargado de dar permisos de ejecución al resto de los
scripts que componen al sistema, y de verificar que la instalación haya
sido satisfactoria. En caso contrario, se sugerirá al usuario que corra
el script Instal4.sh para reparar o instalar nuevamente el sistema. Se
chequeará que todos los scripts que componen al sistema tengan permiso
de ejecución y, en caso de no tenerlos, se dará permiso de ejecución
en modo usuario a los mismos (chmod u+x script.sh).

Al igual que el instalador, Inicio4.sh debe ser ejecutado en el entorno
actual de la terminal, y no en uno hijo, ya que setea variables que serán
usadas por el demonio.

El modo correcto de ejecución es, en el directorio donde se encuentra el
script:
. Inicio4.sh

===== Instrucciones del script de Log =====

El script Glog4.sh escribe un mensaje de un determinado tipo en el archivo
de log de un determinado comando. Por ejemplo, si quisieramos loggear un
advertencia al usuario mientras se ejecuta el comando Inicio4, utilizariamos
el comando Glog4 de la siguiente manera:
./Glog4.sh "Esto es una advertencia" "WARNING" "Inicio4"

Este comando escribiría en el log correspondiente, con un formato específico
para el tipo de mensaje que se esta loggeando. Como se muestra en el ejemplo,
los parámetros del comando son los siguientes:

1 - Mensaje a loggear.
2 - Tipo de mensaje (opcional), puede ser uno de los siguientes:
    * MENSAJE
    * HEADER (para loggear comienzo y fin de ejecucion)
    * ERROR
    * WARNING
    * SEVERE
3 - Comando en cuyo archivo de log se quiere escribir

Los archivos de log pueden alcanzar un tamaño (en Kb) máximo, luego del cual
se borran las primeras entradas y se conservan las últimas, dejando al archivo
en un tamaño más pequeño que el original. Este tamaño esta definido en la
variable LOGSIZE, definida en el instalador. El tamaño con el que se deja
un archivo de log luego de reducirlo es, arbitrariamente, 60 lineas. Luego
de reducirlo en tamaño, se deja constancia en el mismo log que se redujo el
tamaño del mismo.

Además de el mensaje, se guarda registro del usuario que provocó la entrada
de log y la fecha y hora en la que se produjo la entrada.

===== Instrucciones del script de visualización del log =====

El script Vlog4.sh se encarga de mostrar por pantalla las entradas de algun
log en particular que cumplan con algún filtro establecido por el usuario.
Esto facilita la lectura de los archivos de log en el caso de que se quiera
buscar algun registro en particular que se haya realizado en el archivo.

Los parámetros del comando son los siguientes:

-s "palabra o frase a buscar"
-f "comando en cuyo log se buscará"
-n "cantidad máxima de líneas a mostrar"
-i "severidad de los mensajes a mostrar" (opcional)
-u "usuario que provoco la entrada de log" (opcional)

Los parámetros se leen como 'short options' por lo que su orden de aparición
es indistinto para el comando. A continuación se explicará, de manera breve,
que resultado provoca cada parámetro.

-s: buscará la frase o palabra especificada entre comillas en las líneas del
archivo de log especificado. La búsqueda es 'case insensitive' y 'whole words',
es decir, no diferencia entre capitalizaciones pero busca el string especificado
como una palabra completa.

-f: se especifica el comando en cuyo log se buscará. No se debe especificar en
este parámetro el nombre de archivo, ya que el comando Vlog4 conoce la extension
de log especificada en el instalador.

-n: especifica la cantidad máxima de líneas a mostrar. De haber más de n líneas
que cumplan con la búsqueda realizada, se mostrarán las últimas n entradas del
archivo de log.

-i: filtra los mensajes por la severidad especificada, de manera de obtener solo
aquellos mensajes de la severidad pedida (por ejemplo, únicamente los 'SEVERE').

-u: filtra los mensajes por el nombre del usuario que ejecutó el comando que
generó la entrada de log.

Ejemplo de utilización:

./Vlog4.sh -s "No se ha encontrado" -f "Inicio4" -n "10" -i "ERROR"

===== Instrucciones del script utilizado para mover archivos =====

El script Mov4.sh es el encargado de mover archivos de un directorio a otro
(o de cambiarle el nombre si el directorio origen es el mismo que el destino, 
especificando distinto nombre de archivo). La responsabilidad de este script
es de saber responder ante la existencia de un archivo duplicado en el directorio
destino. Es decir, dada la siguiente estructura de archivos:

--grupo4/
  --archivo1.tab
  --tabs/
    --archivo1.tab

Si se quisiera mover el archivo 'archivo1.tab' al directorio 'tabs', estaríamos
ante un archivo duplicado. Este script crea una carpeta 'dup' en el directorio
destino, en donde colocará una secuencia de archivos duplicados (archivo1.tab.1,
archivo1.tab.2, etc). La secuencia generada es específica de cada archivo, de
esta manera, podran existir los archivos duplicados del tipo 'archivo1.tab.1' y
'archivo2.tab.1' dentro del mismo directorio de archivos duplicados.

Los parámetros recibidos por este script son los siguientes:

1 - Path del archivo origen (ejemplo: "grupo4/archivo1.tab").
2 - Path del archivo destino (ejemplo: "grupo4/tabs/archivo1.tab").

Cada tipo de movimiento es loggeado en el archivo de log del comando Mov4. Los
distintos tipos de resultado son los siguientes:

- Archivo y directorio origen es igual a archivo y directorio destino, en cuyo
caso no se realiza ninguna acción.
- No existe el archivo origen, en cuyo caso tampoco se realiza ninguna acción.
- El directorio destino no existe, aquí tampoco se realiza ninguna acción.
- No existe aún un archivo con el nombre destino especificado, en cuyo caso
se mueve el archivo a este directorio sin problemas.
- Existe un archivo con el mismo nombre que el destino especificado, en cuyo
caso se procede a manejar la colisión de la manera antes descripta.

===== Instrucciones de los scripts utilizados para iniciar y detener procesos =====

El script Start4.sh es el encargado de iniciar los procesos que se le pasan
por parámetro.
El script se ejecuta de la siguiente manera:
./Start4.sh proceso_a_iniciar

Start4 se ocupa de verificar la existencia de ese proceso corriendo actualmente
y en dicho caso, no realiza ninguna acción, asentando esto en el log del
usuario.

El script Stop4.sh es el encargado de detener los procesos que se le pasan
por parámetro, ya sea con el nombre del mismo o con el PID.

Los parámetros del comando son los siguientes:

-n "nombre del proceso a detener"
-p "PID del proceso a detener"

Por defecto, si Stop4 recibe ambos parámetros, solamente interpretará el
primero de los dos, desestimando el otro.

Ejemplos de ejecución del script:
./Stop4.sh -n nombre_proceso_a_detener
./Stop4.sh -p PID_proceso_a_detener

Stop4 se ocupa de verificar la existencia de ese proceso corriendo actualmente
y en dicho caso, lo detendrá luego de obtener su PID.

===== Interprete =====


La funcion del interprete es traducir, de los diferentes formatos de archivos que arriban, a un formato standar que interpreta el sistema.

Este script puede ser ejecutado independientemente de la siguiente manera "./Interprete" y no recibe parametros pero utiliza internamente las variables globales $ACEPDIR ,$CONFDIR, $PROCDIR y $RECHDIR, por lo que deben estar obligatoriamente seteadas antes de su ejecucion, por lo tanto se debe ejecutar luego de la instalacion.

Ademas es condicion obligatoria para el correcto funcionamiento del interprete, que existan en $CONFDIR los archivos T1 y T2 , ya que son los archivos que permiten realizar la principal tarea del interprete que es la de Traducir los diferentes formatos.


