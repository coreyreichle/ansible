This is a working playbook, that steps the user though building a basic playbook for Ansible, using the provided best practices.  From start to finish, this playbook should take ~1 hour to complete, due to the lxc container creation, and package installation on the containers.

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
Let's go ahead and get all of your baseline config completed:
```
ansible-playbook site.yml -i ./hosts --limit control -k -K
```
This should execute your playbook against just the control workstation.

Then, let's provision the workstations:

```
ansible-playbook site.yml -i ./hosts  --limit workstations -k -K
```

The --limit flag limits you to just the provided group which contains the machines in the groups specified in the hosts file.

Now, let's provision the balance of the machines:
```
ansible-playbook site.yml -i ./hosts  -k -K
```

At this point, you should be able to go to http://web01.lxc and see the hello world php file, which should show you the DB connection information as well.

#Explaining the Playbook
The best way to break down your play are by role, and this is what I've done here, segregating various roles for a simple web stack, plus a control workstation and a plain-jane workstation.

##Common role
The "common" role is what applies to every machine you own (It captures all hosts, per the site.yml file).  It consists only of tasks at this point.

The file roles/common/tasks/main.yml merely includes several other tasks to be done:  packages.yml, sudoers.yml and users.yml.

The first call is packages.yml, which just installs some packages we want on every machine.  In that play, you see how you can work with a list of items to perform the same action with.

Then, we call users.yml.  Here, we first create a group for the ansible called "ansible", then we create a user called "ansible".  You'll notice a glob of what looks to be random characters.  This is the md5 hash for this user's password (ansible).

Then, sudoers.yml gets referenced.  This file demonstrates the copy module, where we we copy a file up to the machine, and set it's permissions.  It also demonstrates creating a group, and adding the ansible user to this group.

##Workstation Role
This role is pretty simple, and a whole lot alike to the Common role:  Create another user, add some more packages.  This one demonstrates how to deploy cron jobs though as well.  If you note, the combined list of packages includes what is installed from common, as well as packages added here.  However, the rest of the machines will not get the packages specified here.

If you were to use this playbook, you can specify a baseline of packages and basic configurations you want to be given to all of your workstations.  IDE's, and whatnot are good to add here, and you can further break out roles to include workstations, and developer workstations as an example.

##Control Role
If you're running this playbook, everything here should already be set up.  However, you can also use this to deploy central control workstations.

##DB Role
The DB role installs mysql, creates a database, and a database user called "webapp" with a password of "ansible".  This one is another that shows how to use variable files to use in your templates.

##Web Role
This role deploys apache2, php5, and all required packages to connect to a mysql database.  It also deploys a simple webapp, which is really just a index.html file that is templated.  It writes out the host name that you're connected to, and the db servers this webapp would use.

This demonstrates how to use the variables and a looping structure in jinja2 templates.  After this role is deployed, you can hit either http://web01.lxc/index.html or http://web02.lxc/index.html to view the two separate pages.
