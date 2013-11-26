#!/bin/bash
#Configurar En la maquina


#GNS3
GNS3_IP="192.168.0.6"
GNS3_BRCST="192.168.0.255"
GNS3_MASK="255.255.255.0"

#WEBSERVER
WEBSERVER_TAP_IP="192.168.3.1"
WEBSERVER_TAP_BRCST="192.168.3.255"
WEBSERVER_TAP_MASK="255.255.255.0"
WEBSERVER_INTF_IP="10.0.0.2"

#TELSERVER1 Y 2
TELSERVER1_TAP_IP="10.24.1.65"
TELSERVER1_TAP_BRCST="10.24.1.127"
TELSERVER1_TAP_MASK="255.255.255.128"

TELSERVER2_TAP_IP="10.24.1.129"
TELSERVER2_TAP_BRCST="10.34.1.159"
TELSERVER2_TAP_MASK="255.255.255.224"

TELSERVER_INTF_IP="10.0.0.3"

#DNS ROOT
DNSROOT_TAP_IP="10.24.1.5"
DNSROOT_TAP_BRCST="10.24.1.127"
DNSROOT_TAP_MASK="255.255.255.128"
DNSROOT_INTF_IP="10.0.0.4"

#DNS1
DNS1_TAP_IP="192.168.8.5"
DNS1_TAP_BRCST="192.168.8.255"
DNS1_TAP_MASK="255.255.255.0"
DNS1_INTF_IP="192.168.0.7"

#DNS2
DNS2_TAP_IP="10.24.3.134"
DNS2_TAP_BRCST="10.10.5.255"
DNS2_TAP_MASK="255.255.255.0"
DNS2_INTF_IP="10.0.0.8"

#FTP
FTP_TAP_IP="10.92.27.1"
FTP_TAP_BRCST="10.92.27.31"
FTP_TAP_MASK="255.255.255.224"
FTP_INTF_IP="10.0.0.7"

#HOST A
HOSTA_TAP_IP="10.24.3.135"
HOSTA_TAP_BRCST="10.24.3.255"
HOSTA_TAP_MASK="255.255.255.128"
HOSTA_INTF_IP="10.0.0.8"

#HOST B
HOSTB_TAP_IP="10.24.3.67"
HOSTB_TAP_BRCST="10.24.3.127"
HOSTB_TAP_MASK="255.255.255.192"
HOSTB_INTF_IP="10.0.0.9"

#HOST C
HOSTC_TAP_IP="10.10.5.6"
HOSTC_TAP_BRCST="10.10.5.255"
HOSTC_TAP_MASK="255.255.255.0"
HOSTC_INTF_IP="10.0.0.10"

#PUERTOS
WEBSERVER_GNS3_PORT=9000
WEBSERVER_PORT=8000

TELSERVER1_GNS3_PORT=9001
TELSERVER1_PORT=8001

TELSERVER2_GNS3_PORT=9002
TELSERVER2_PORT=8002

DNSROOT_GNS3_PORT=9003
DNSROOT_PORT=8003

DNS1_GNS3_PORT=9004
DNS1_PORT=8004

DNS2_GNS3_PORT=9005
DNS2_PORT=8005

FTP_GNS3_PORT=9006
FTP_PORT=8006

HOSTA_GNS3_PORT=9007
HOSTA_PORT=8007

HOSTB_GNS3_PORT=9008
HOSTB_PORT=8008

HOSTC_GNS3_PORT=9009
HOSTC_PORT=8009

#GATEWAY
WEBSERVER_GTWY="192.168.8.1"
TELSERVER_GTWY="10.24.1.2"
DNSROOT_GTWY="10.24.1.1"
DNS1_GTWY="192.168.8.4"
DNS2_GTWY="10.24.3.133"
FTP_GTWY="10.92.27.3"
HOSTA_GTWY="10.24.3.133"
HOSTB_GTWY="10.24.3.67"
HOSTC_GTWY="10.10.5.5"

#HOST DNS SERVER
DOMAIN="chubut.dc.fi.uba.ar"
SEARCH="chubut.dc.fi.uba.ar"
WEBSERVER_NS="192.168.8.4"
TELSERVER_NS="192.168.8.4"
FTP_NS="10.24.3.134"
HOSTA_NS="10.24.3.134"
HOSTB_NS="192.168.8.4"
HOSTC_NS="10.24.3.134"
