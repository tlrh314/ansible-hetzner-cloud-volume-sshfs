#!/bin/bash
set -e


KEY=~/.ssh/hcloud_sshfs_rsa


create_key() {
    if [ ! -f "${KEY}"  ]; then
        ssh-keygen -t rsa -C "MyComputer --> Hetzner Cloud" -f "${KEY}"
    fi
    hcloud ssh-key create --public-key-from-file="${KEY}".pub --name my-ssh-key
}
delete_key() {
    hcloud ssh-key delete my-ssh-key || true
}


create_network() {
    hcloud network create --name network --ip-range 10.0.0.0/24
    hcloud network add-subnet network --type server --network-zone eu-central --ip-range 10.0.0.0/28
}
delete_network() {
    hcloud network delete network || true
}


create_servers() {
    hcloud server create --location nbg1 --ssh-key my-ssh-key --type cx11 --image debian-10 --name server1
    hcloud server create --location nbg1 --ssh-key my-ssh-key --type cx11 --image debian-10 --name server2
    hcloud server attach-to-network server1 --network network --ip 10.0.0.2
    hcloud server attach-to-network server2 --network network --ip 10.0.0.3
}
delete_servers() {
    hcloud server delete server1 || true
    hcloud server delete server2 || true
}

create_volume() {
    hcloud volume create --size 10 --name storage --server server1 --format ext4 --automount
}
delete_volume() {
    hcloud volume detach storage || true
    hcloud volume delete storage || true
}


while [[ $# -gt 0 ]]
do
key="$1"
case $key in
  -c)
    create_key
    create_network
    create_servers
    create_volume
    shift # past argument
    shift # past value
  ;;
  -d)
    delete_volume
    delete_servers
    delete_network
    delete_key
    shift # past argument
    shift # past value
  ;;
  *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
  ;;
esac
done
