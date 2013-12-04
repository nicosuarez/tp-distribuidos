#!/bin/bash
#Test de conectividad para Rio Negro

function parse {
	ping -c 4 $1  | grep --color=always "PING\|4 packets\|errors\|100\%"
}

function println {
	echo "-"
	echo $1
}

clear
echo "########### RED H ############"
println "Ping a R13 - H"
parse 192.168.8.65
println "Ping a R14 - H"
parse 192.168.8.66
println "Ping a R13/R14 VRRP - H"
parse 192.168.8.67
println "Ping a Webserver - H"
parse 192.168.8.71
echo "########### RED I ############"
println "Ping a R12 - I"
parse 10.10.5.1
println "Ping a R13 - I"
parse 10.10.5.2
println "Ping a R14 - I"
parse 10.10.5.3
println "Ping a R13/R14 VRRP - I"
parse 10.10.5.4
println "Ping a DNS 1 - I"
parse 10.10.5.5
println "Ping a HOST B - I"
parse 10.10.5.6
echo "########### RED J ############"
println "Ping a R14 - J"
parse 10.24.1.113
echo "########### RED K ############"
println "Ping a R16 - K"
parse 10.92.27.137
echo "########### RED L ############"
println "Ping a R14 - L"
parse 10.24.1.33
println "Ping a R15 - L"
parse 10.24.1.34
println "Ping a R16 - L"
parse 10.24.1.35




