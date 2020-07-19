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
    hcloud ssh-key delete my-ssh-key
}


create_network() {
    hcloud network create --name network --ip-range 10.0.0.0/24
    hcloud network add-subnet network --type server --network-zone eu-central --ip-range 10.0.0.0/28
}
delete_network() {
    hcloud network delete network
}


create_servers() {
    hcloud server create --location nbg1 --ssh-key my-ssh-key --type cx11 --image debian-10 --network network --name server1
    hcloud server create --location nbg1 --ssh-key my-ssh-key --type cx11 --image debian-10 --network network --name server2
}
delete_servers() {
    hcloud server delete server1
    hcloud server delete server2
}

create_volume() {
    hcloud volume create --size 10 --name storage --server server1 --format ext4 --automount
}
delete_volume() {
    hcloud volume detach storage
    hcloud volume delete storage
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
