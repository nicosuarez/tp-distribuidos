#!/bin/bash
#Test de conectividad para Trelew

function parse {
	ping -c 4 $1  | grep --color=always "PING\|4 packets\|errors\|100\%"
}

function println {
	echo "-"
	echo $1
}

clear
echo "########### RED A ############"
echo "Ping a FTP - A"
parse 10.92.27.1
println "Ping a R1 - A"
parse 10.92.27.2
println "Ping a R2 - A"
parse 10.92.27.3
println "Ping a R3 - A"
parse 10.92.27.4
println "Ping a R6 - A"
parse 10.92.27.5
println "Ping a HOST C - A"
parse 10.92.27.6
println "Ping a R2/R3 VRRP - A"
parse 10.92.27.7
echo "########### RED B ############"
println "Ping a R2 - B"
parse 10.24.3.1
println "Ping a R3 - B"
parse 10.24.3.2
println "Ping a R4 - B"
parse 10.24.3.3
println "Ping a R5 - B"
parse 10.24.3.4
println "Ping a DNS2 - B"
parse 10.24.3.5
println "Ping a R2/R3 VRRP - B"
parse 10.24.3.6
echo "########### RED C ############"
println "Ping a R4 - C"
parse 10.92.27.129
println "Ping a R7 - C"
parse 10.92.27.130



