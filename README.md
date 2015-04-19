This is a working playbook, that steps the user though building a basic playbook for Ansible, using the provided best practices.

At this time, the playbook is incomplete, and may not finish to the end.

#Setup your environment
Clone down this repo:

```
  cd ~ ; git clone https://github.com/coreyreichle/ansible.git ; cd ~/ansible
```
Make sure LXC is installed

```
sudo apt-get install lxc ansible
```

Now, create your containers, and link the provided hosts file to /etc/ansible/hosts:

```
for i in web01 web02 db01 work01; do sudo lxc-create -n $i -t ubuntu; done; sudo ln -s `pwd`/hosts /etc/ansible/hosts
```

Start your containers:
```
for i in web01 web02 db01 work01; do sudo lxc-start -n $i; done; sudo lxc-ls --fancy
```
At this point, you should see the fancy lxc display, complete with IP addresses for your containers.  If you don't see the IP's, wait a minute, and execute the lxc-ls command again.  Once your machines are connected, proceed to the next step.

#Provision your LXC containers
Let's go ahead and make sure your workstation is functioning correctly:
```
ansible-playbook site-yml --limit control
```
This should execute your playbook against just the control workstation.

Then, let's provision the workstations:

```
ansible-playbook site.yml --limit workstations
```

The --limit flag limits you to just the provided group which contains the machines in the groups specified in the hosts file.

Now, let's provision the balance of the machines:
```
ansible-playbook site.yml
```

At this point, you should be able to go to http://web01.lxc and see the hello world php file, which should show you the DB connection information as well.
