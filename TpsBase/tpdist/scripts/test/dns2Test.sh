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
echo "########### RED D ############"
echo "Nslookup a R9 - D"
parse 10.24.1.1
println "Nslookup a R8 - D"
parse 10.24.1.2
println "Nslookup a R7 - D"
parse 10.24.1.3
println "Nslookup a HOST A"
parse 10.24.1.4
echo "########### RED E ############"
echo "Nslookup a R9 - E"
parse 10.24.1.97
println "Nslookup a R10 - E"
parse 10.24.1.98
echo "########### RED F ############"
echo "Nslookup a R11 - F"
parse 10.92.27.133
println "Nslookup a R12 - F"
parse 10.92.27.134
echo "########### RED G ############"
echo "Nslookup a Telnet - G"
parse 10.24.1.129
println "Nslookup a R10 - G"
parse 10.24.1.130
println "Nslookup a R7 - G"
parse 10.24.1.131
println "Nslookup a R11 - G"
parse 10.24.1.132
println "Nslookup a DNS Root - G"
parse 10.24.1.133
echo "########### RED N ############"
echo "Nslookup a Telnet - N"
parse 10.24.1.65
println "Nslookup a R11 - N"
parse 10.24.1.66
println "Nslookup a R17 - N"
parse 10.24.1.67
echo "########### RED H ############"
println "Nslookup a R13 - H"
parse 192.168.8.65
println "Nslookup a R14 - H"
parse 192.168.8.66
println "Nslookup a R13/R14 VRRP - H"
parse 192.168.8.67
println "Nslookup a Webserver - H"
parse 192.168.8.71
echo "########### RED I ############"
println "Nslookup a R12 - I"
parse 10.10.5.1
println "Nslookup a R13 - I"
parse 10.10.5.2
println "Nslookup a R14 - I"
parse 10.10.5.3
println "Nslookup a R13/R14 VRRP - I"
parse 10.10.5.4
println "Nslookup a DNS 1 - I"
parse 10.10.5.5
println "Nslookup a HOST B - I"
parse 10.10.5.6
echo "########### RED J ############"
println "Nslookup a R14 - J"
parse 10.24.1.113
echo "########### RED K ############"
println "Nslookup a R16 - K"
parse 10.92.27.137
echo "########### RED L ############"
println "Nslookup a R14 - L"
parse 10.24.1.33
println "Nslookup a R15 - L"
parse 10.24.1.34
println "Nslookup a R16 - L"
parse 10.24.1.35



