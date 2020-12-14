# Running the App with playbooks
- First, ensure you have 3 AWS instances running
  - Ansible controller machine which we will use to provision our host instances
  - App Host machine which will be used to run the application from and access it via the public ip address of the instance
  - DB Host machine which will have mongod installed and will be connected to the App Host machine

- Copy over the `ansible_bash.sh` `app_setup.yaml` and `db_playbook.yaml` into your ansible controller by using the `scp -i ` command in bash
- You also want to copy over your AWS key pair which will allow you to SSH and provision your Host instances
- SSH into the ansible controller and run the `ansible_bash.sh` file which will install Ansible on the controller and allow you to provision to host machines.
- In your ansible controller, add the app/db hosts into your `/etc/ansible/hosts` file
```yaml
[app_host]
172.31.37.104 ansible_connection=ssh ansible_ssh_private_key_file=/home/ubuntu/.ssh/eng74mattawskey.pem

[db_host]
172.31.35.17 ansible_connection=ssh ansible_ssh_private_key_file=/home/ubuntu/.ssh/eng74mattawskey.pem
```
- Now we should be able to simply run the playbooks to set up our instances with the DB and App.
- To this, simply navigate to the directory where you copied your playbooks into and run the db and app playbooks in that order with the command: `ansible-playbook <playbookname.yaml>`
- Once you do this for both playbooks, the app should be running and you can see that by navigating to the Public IP of the App Host instance

