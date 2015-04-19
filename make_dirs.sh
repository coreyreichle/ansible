#!/bin/bash

# Script to create ansible playbook directories

# define your roles here
roles=(common webservers dbservers workstations control)
directories=(tasks handlers templates files vars defaults meta)

# create playbook
mkdir global_vars
mkdir roles
mkdir library
mkdir filer_plugins
mkdir host_vars
mkdir production
mkdir stage

for i in ${roles[@]}; do
  for j in ${directories[@]}; do
    mkdir -p roles/${i}/${j}
  done
done

for i in ${roles[@]}; do
  touch roles/$i/tasks/main.yml
  touch roles/$i/handlers/main.yml
  touch roles/$i/vars/main.yml
  touch roles/$i/meta/main.yml
done

touch site.yml
touch hosts

exit 0
