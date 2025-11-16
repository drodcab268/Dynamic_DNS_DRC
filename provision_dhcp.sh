#!/bin/bash

# Instala servicio DHCP..."
apt update
apt install dhcpd -y

# Copia configuración dhcpd.conf
cp /vagrant/dhcpd.conf /etc/dhcp/dhcpd.conf

# copia la clave generada en el DNS
sshpass -p vagrant scp -o StrictHostKeyChecking=no vagrant@192.168.58.10:/etc/bind/ddns.key /etc/dhcp/ddns.key

systemctl restart isc-dhcp-server