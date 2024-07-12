Ansible is a configuration management tool by Redhat And developed using python.
It is used to automate the tasks mainly use in infrastructure and applications management.
It allows you to deploy and update applications using SSH without agent installation on remote hosts.
You can manage and configure infra and applications on remote hosts using "yaml" by writing "playbooks" for setof tasks.
For executing one or two commands on remote hosts we can use "adhoc" commands.
By default inventory file is located at /etc/ansible/hosts.
Inventory file is used to store remote hosts IP's to communicate with them.
python is the prerequisite for ansible to run.

SETTING UP ANSIBLE & HOST Machines:

1.After Installation, we have to enable password less authentication for control machine & remote host to manage configuration in remote hosts.
for that we need to keep controller machines public.key in remote host .ssh/authrozation file
2.And need to add servers IP's into the inventory file so ansible can manage those nodes by using ssh protocol.

Example for adhoc commands:
1.To execute shell commands on remote host
ansible -i inventory all -m "shell" -a "touch /home/ubuntu/dummy-1.txt"

Example for playbooks:
1.Suppose you want to install nginx on remote host and start
create a playbook using yml extention "playbook-nginx.yml"
To start writing ansible playbook start with 3 hypens[---]
---
- name:Install and start nginx
  hosts: all
  become: root
  
  tasks:
    - name: Install nginx
	  apt:            # we used apt module as ansible providing "apt" package manager or we can run shell command aswell
	    name: nginx  
		state: present
	- name: Start nginx
	  service:
	     name: nginx
		 state: started
		
