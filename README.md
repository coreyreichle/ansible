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

Now, create your containers:

```
for i in web01 web02 db01 work01; do sudo lxc-create -n $i -t ubuntu; done
```

Start your containers:
```
for i in web01 web02 db01 work01; do sudo lxc-start -n $i; done; sudo lxc-ls --fancy
```
At this point, you should see the fancy lxc display, complete with IP addresses for your containers.  If you don't see the IP's, wait a minute, and execute the lxc-ls command again.  Once your machines are connected, proceed to the next step.

Now, Ansible does require Python installed, so you can either use a custom Ubuntu template which installs it as a part of the initial provisioning.  However, I'm trying to stick with vanilla setup, so execute the following to install python:
```
for i in `sudo lxc-ls`; do sudo lxc-attach -n $i -- /usr/bin/apt-get -y install python ; done
```

You should be able to test it, by using the ping module from Ansible, and when promoted, enter the default password (ubuntu):
```
ansible -i ./hosts all -m ping -u ubuntu -k
```

#Provision your LXC containers
Let's go ahead and make sure your workstation is functioning correctly:
```
ansible-playbook site-yml -i ./hosts --limit control
```
This should execute your playbook against just the control workstation.

Then, let's provision the workstations:

```
ansible-playbook site.yml -i ./hosts  --limit workstations
```

The --limit flag limits you to just the provided group which contains the machines in the groups specified in the hosts file.

Now, let's provision the balance of the machines:
```
ansible-playbook site.yml -i ./hosts 
```

At this point, you should be able to go to http://web01.lxc and see the hello world php file, which should show you the DB connection information as well.
