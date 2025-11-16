#!/bin/bash

# Installing ISC-DHCP-Server
apt update
apt install isc-dhcp-server sshpass -y

# Configure DHCP to listen on eth1
echo 'INTERFACESv4="eth1"' > /etc/default/isc-dhcp-server
echo 'INTERFACESv6=""' >> /etc/default/isc-dhcp-server

# Copying TSIG key from shared folder
cp /vagrant/ddns.key /etc/dhcp/ddns.key

# Deploying DHCP configuration
cp /vagrant/dhcpd.conf /etc/dhcp/dhcpd.conf

# Restart ISC DHCP server
systemctl restart isc-dhcp-server