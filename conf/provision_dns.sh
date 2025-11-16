#!/bin/bash

set -xeu

# Installing BIND9
apt-get update
apt-get install -y bind9 dnsutils

# Generate TSIG key and save it in /vagrant (shared folder)
tsig-keygen -a hmac-sha256 ddns-key > /vagrant/ddns.key

# Copy TSIG key into Bind folder
cp /vagrant/ddns.key /etc/bind/ddns.key

SECRET=$(grep secret /vagrant/ddns.key | awk '{print $2}' | tr -d '";')

# Adding TSIG key to named.conf.options
cat >> /etc/bind/named.conf.options <<EOF

key "ddns-key" {
    algorithm hmac-sha256;
    secret "$SECRET";
};
EOF

# Creating DNS zone definitions
cat > /etc/bind/named.conf.local <<EOF
zone "drodcab.es" IN {
    type master;
    file "/var/lib/bind/db.drodcab.es";
    allow-update { key "ddns-key"; };
};

zone "58.168.192.in-addr.arpa" IN {
    type master;
    file "/var/lib/bind/db.192";
    allow-update { key "ddns-key"; };
};
EOF

# Deploying zone files
cp /vagrant/conf/zones/drodcab_es.txt /var/lib/bind/db.drodcab.es
cp /vagrant/conf/zones/drodcab_rev.txt /var/lib/bind/db.192

# Restarting BIND9
systemctl restart bind9