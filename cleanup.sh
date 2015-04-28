#!/bin/bash

for i in db01 web web01 web02 work01; do sudo lxc-stop -n $i; ssh-keygen -R $i.lxc; sudo lxc-destroy -n $i; done
