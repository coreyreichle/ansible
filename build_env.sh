#!/bin/bash

for i in web01 web02 web db01 work01; do sudo lxc-create -n $i -t ubuntu; done

for i in web01 web02 web db01 work01; do sudo lxc-start -n $i; done; sudo lxc-ls --fancy

sleep 60;

for i in `sudo lxc-ls`; do sudo lxc-attach -n $i -- /usr/bin/apt-get -y install python ; done

ansible -i ./hosts all -m ping -u ubuntu -k

ansible-playbook site.yml -i ./hosts  -k -K
