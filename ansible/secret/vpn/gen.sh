#!/bin/sh

hostcert() {
    nebula-cert sign -name "$1" -ip "$2" -groups "$3"
}



nebula-cert ca --name "Void Linux"

# Workstations are below 50
hostcert theGibson 192.168.99.10/24 workstation

# Hosts Start at 100
hostcert vm2-a-lej-de 192.168.99.100/24 base,netauth
hostcert vm1-a-mci-us 192.168.99.101/24 base,nomad-client
hostcert a-hel-fi 192.168.99.102/24 base,nomad-client
hostcert b-lej-de 192.168.99.103/24 base,nomad-client
hostcert c-lej-de 192.168.99.104/24 base,nomad-client

hostcert a-sfo3-us 192.168.99.105/24 base,netauth
hostcert b-sfo3-us 192.168.99.106/24 base,nomad-server
hostcert c-sfo3-us 192.168.99.107/24 base,nomad-server
hostcert d-sfo3-us 192.168.99.108/24 base,nomad-server
