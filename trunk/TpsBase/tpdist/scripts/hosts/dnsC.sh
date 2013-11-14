#!/bin/bash
# Script para tener internet en la maquina conectada a la VPN. Cambiar
# La segunda linea por  el IP del nameserver adecuado

echo "nameserver 10.24.1.133" > /etc/resolv.conf
echo "nameserver 192.168.1.1" >> /etc/resolv.conf
