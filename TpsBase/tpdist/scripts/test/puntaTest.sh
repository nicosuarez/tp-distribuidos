#!/bin/bash
#Test de conectividad para Punta Indio

function parse {
	ping -c 4 $1  | grep --color=always "PING\|4 packets\|errors\|100\%"
}

function println {
	echo "-"
	echo $1
}

clear
echo "########### RED D ############"
echo "Ping a R9 - D"
parse 10.24.1.1
println "Ping a R8 - D"
parse 10.24.1.2
println "Ping a R7 - D"
parse 10.24.1.3
println "Ping a HOST A"
parse 10.24.1.4
echo "########### RED E ############"
echo "Ping a R9 - E"
parse 10.24.1.97
println "Ping a R10 - E"
parse 10.24.1.98
echo "########### RED F ############"
echo "Ping a R11 - F"
parse 10.92.27.133
println "Ping a R12 - F"
parse 10.92.27.134
echo "########### RED G ############"
echo "Ping a Telnet - G"
parse 10.24.1.129
println "Ping a R10 - G"
parse 10.24.1.130
println "Ping a R7 - G"
parse 10.24.1.131
println "Ping a R11 - G"
parse 10.24.1.132
println "Ping a DNS Root - G"
parse 10.24.1.133
echo "########### RED N ############"
echo "Ping a Telnet - N"
parse 10.24.1.65
println "Ping a R11 - N"
parse 10.24.1.66
println "Ping a R17 - N"
parse 10.24.1.67


