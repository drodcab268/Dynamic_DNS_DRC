#!/bin/bash

#Instala BIND9
apt update
apt install bind9 dnsutils -y

# Genera clave TSIG
tsig-keygen -a hmac-sha256 ddns-key > /etc/bind/ddns.key

SECRET=$(grep secret /etc/bind/ddns.key | awk '{print $2}' | tr -d '";')

# Configura BIND9
cat > /etc/bind/named.conf.local <<EOF
zone "example.test" IN {
    type master;
    file "/etc/bind/db.example.test";
    allow-update { key "ddns-key"; };
};

zone "58.168.192.in-addr.arpa" IN {
    type master;
    file "/etc/bind/db.192";
    allow-update { key "ddns-key"; };
};
EOF

cat >> /etc/bind/named.conf.options <<EOF

key "ddns-key" {
    algorithm hmac-sha256;
    secret "$SECRET";
};
EOF

# ZONA DIRECTA
cp /etc/bind/db.local /etc/bind/db.example.test
sed -i 's/localhost./example.test./' /etc/bind/db.example.test

# ZONA INVERSA
cp /etc/bind/db.127 /etc/bind/db.192
sed -i 's/127.0.0.1/192.168.58.10/' /etc/bind/db.192
sed -i 's/localhost./example.test./' /etc/bind/db.192

systemctl restart bind9