# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"

  # DNS SERVER
  config.vm.define "dns01" do |dns|
    dns.vm.hostname = "dns01"
    dns.vm.network "private_network", ip: "192.168.58.10"
    dns.vm.provision "shell", path: "./provision-dns.sh"
  end

  # DHCP SERVER
  config.vm.define "dhcp01" do |dhcp|
    dhcp.vm.hostname = "dhcp01"
    dhcp.vm.network "private_network", ip: "192.168.58.11"
    dhcp.vm.provision "shell", path: "./provision-dhcp.sh"
  end

  # CLIENTE
  config.vm.define "client" do |cli|
    cli.vm.hostname = "client"
    cli.vm.network "private_network", type: "dhcp"
  end
end