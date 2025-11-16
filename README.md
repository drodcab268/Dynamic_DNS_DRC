# Dynamic DHCP + DNS Practice  

In this repository we have a DHCP sever, a DNS server and a client; all hosted on a debian12 box.

The goal is that the DHCP server dynamically updates the DNS records thanks to Dynamic DNS:
- Deploys a DNS server (BIND9).
- Deploys a DHCP server (ISC-DHCP-Server).
- Configures secure key "TSIG authentication" between the servers.
- The DHCP server will:
  - Assign dynamic IP addresses to the client.
  - Automatically create DNS records via DDNS.
- Test it with the client machine.



## Requirements:

- Virtualbox.
- Vagrant.
- Internet connection.


If you don’t have them installed, you could set them up with:

### Linux:
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y virtualbox 
sudo apt install -y vagrant
```
### Windows:
- [VirtualBox](https://download.virtualbox.org/virtualbox/7.2.2/VirtualBox-7.2.2-170484-Win.exe)
- [Vagrant](https://releases.hashicorp.com/vagrant/2.4.9/vagrant_2.4.9_windows_amd64.msi)



## Comands for ussage:

### 1. Clone the repository.
```bash
git clone https://github.com/drodcab268/Dynamic_DNS_DRC.git

cd ./Dynamic_DNS_DRC
```
### 2. Start the virtual machine.
```bash
vagrant up
```
### 3. Connect to the DHCP server.
```bash
vagrant ssh dhcp01
```
### 4. Verify that the DHCP service is active and working properly.
```bash
sudo systemctl status isc-dhcp-server
sudo dhclient -r
sudo dhclient -v
```
### 5. Connect to the client.
```bash
vagrant ssh client
```
### 6. Verify the client IP is set correctly and work.
```bash
ip a
sudo dhclient -v
ping 192.168.58.10
ping 192.168.58.20
```
### 7. Test the DNS records from client.
```bash
dig client.drodcab.es
dig -x <dynamic_IP_from_client>
```
### (Optional). Shut down and unistallation.
```bash
vagrant halt
vagrant destroy -f
```



## Details about this project:

### Network Configuration

| Machine       | Role                | Network            | Interface | IP / Method           |
|---------------|---------------------|--------------------|-----------|------------------------|
| **dns01**     | DNS Server (BIND9)  | 192.168.58.0/24    | eth1      | 192.168.58.10 (static) |
| **dhcp01**    | DHCP Server (ISC)   | 192.168.58.0/24    | eth1      | 192.168.58.20 (static) |
| **client01**  | Client Machine      | 192.168.58.0/24    | eth1      | DHCP (dynamic)         |


### Information about errors and recomendations:

While doing this project we have encountered some issues like...

- **DDNS.KEY:** When stablishing the generation of the ddns.key it's important to copy it into the vagrant shared folder, like that we can acces the same key from both servers, saving us from headaches when trying to share the key.

- **/var/lib/bind/:** It's important to stablish the zones in the DNS server inside /var/lib/bind instead of /etc/bind, like that BIND will be able to update the zones for the dynamic DNS.


## That's all folks:

Thanks for readding, and we hope it works for you all too!

### Created by:

- Daniel Rodríguez Cabello

from 2º ASIR-B [[IES Zaidín Vergeles](https://www.ieszaidinvergeles.org/)].