#!/bin/bash
#Test de dns reverso para DNS1 (Trelew)

function parse {
	nslookup $1 | grep --color=always "name = \|NXDOMAIN"
}

function println {
	echo "-"
	echo $1
}

clear
echo "########### RED A ############"
echo "Nslookup a FTP - A"
parse 10.92.27.1
println "Nslookup a R1 - A"
parse 10.92.27.2
println "Nslookup a R2 - A"
parse 10.92.27.3
println "Nslookup a R3 - A"
parse 10.92.27.4
println "Nslookup a R6 - A"
parse 10.92.27.5
println "Nslookup a HOST C - A"
parse 10.92.27.6
println "Nslookup a R2/R3 VRRP - A"
parse 10.92.27.7
echo "########### RED B ############"
println "Nslookup a R2 - B"
parse 10.24.3.1
println "Nslookup a R3 - B"
parse 10.24.3.2
println "Nslookup a R4 - B"
parse 10.24.3.3
println "Nslookup a R5 - B"
parse 10.24.3.4
println "Nslookup a DNS2 - B"
parse 10.24.3.5
println "Nslookup a R2/R3 VRRP - B"
parse 10.24.3.6
echo "########### RED C ############"
println "Nslookup a R4 - C"
parse 10.92.27.129
println "Nslookup a R7 - C"
parse 10.92.27.130



