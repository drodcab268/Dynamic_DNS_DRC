#!/bin/bash

set -xeu

# Installing ISC-DHCP-Server
apt-get update
apt-get install -y isc-dhcp-server net-tools iproute2

# Deploying DHCP configuration
cp /vagrant/conf/dhcpd.conf /etc/dhcp/dhcpd.conf

# Configure DHCP to listen on eth1
sed -i 's/^INTERFACESv4=.*/INTERFACESv4="eth1"/' /etc/default/isc-dhcp-server

# Copying TSIG key from shared folder
cp /vagrant/ddns.key /etc/dhcp/ddns.key

# Restart ISC DHCP server
systemctl restart isc-dhcp-server
systemctl enable isc-dhcp-server
systemctl status isc-dhcp-server --no-pager