# IAC Ansible
Ansible is a software tool which can provide automation in cloud-provisioning, configuration management, application deployment and intra-service orcheastration. An IAC tool.

[Additional Notes](https://github.com/MattSokol79/Ops_Notes/tree/main/Week_8_VPC_Continued/Day3_Ansible)

## How it works
- There are two categories of nodes, the main control node and managed nodes.
  - The control node machine actually runs Ansible
  - Managed nodes are machines which we want to change with Ansible. 
- So we essentially set up a controller node and write ansible code/playbooks which will automate the process of provisioning our managed nodes.

## How to set it up
- We are setting up our controller machine in aws. 
- `ansible_bash.sh` is a script that will install ansible & associated dependencies. 
- Create EC2 instance for `ansible-controller`
- Create EC2 instance for `hostA`
  
- We connect `hostA` similarly to private instance in VPC -> `ansible-controller` SSH into `hostA`.
  - Send the aws key into the ansible controller so it can ssh into `hostA`
  - We need to create a SG group for the hosts so that they can only be accessed by the ansible controller
    - SG port should just be the SG used by the ansible controller which means only those instances with that particular SG will be allowed to SSH in -> in this case always use Private IP to SSH in.

## Hosts
- chmod 400 <AWS key to allow it read permissions to be used>
- `cd /etc/ansible` and nano `hosts`
- At the bottom of the file add in:

```bash
[host_a]
172.31.37.104 ansible_connection=ssh ansible_ssh_private_key_file=/home/ubuntu/.ssh/eng74mattawskey.pem
```

## Main commands
- We can check our connection with the host by running the command:
```bash
ansible host_a -m ping
``` 

**ping all hosts**
```bash
ansible all -m ping
```

**Run this command in the host**
```bash
ansible all -a "command" # -----> Any command in there
ansible host_a -a "sudo apt-get update" # -----> Update packages
ansible all -a "uname -a" # -----> Details
ansible host_a -a "uptime" # -----> How long node has been up and running
```

**Update and upgrade host**
`ansible host_a -m apt -a "upgrade=yes update_cache=yes" --become`

## Writing a Playbook
This section will cover:
- Main structure
  - How to start a playbook
```yaml
ansible-playbook <playbook_name>
```
  - How to define where it runs (in the file)
  - How to make tasks

### Writing a Task/How to provision
- **Ansible standard modules**
  - copy
  - file
  - apt
  - community.general.npm
- **Handlers**
  -  We need to manage services `systemctl start nginx` for example
  -  Ansible has two ways to manager services
     -  The module service
     -  Handlers/notification system
     -  Handler is like a class in python -> Can call it under any task once defined (Inheritance)
```yaml
# Start and enable nginx
- name: Start nginx
  service: 
    name: nginx
    # state: restarted
    state: started
    enabled: yes

# Build notification system to restart nginx -> can call this multiple times with notify in other tasks
handlers:
  - name: Restart nginx
    ansible.builtin.service:
      name: nginx
      state: restarted
```
      - Then in a task you can call said handler with -> notify
```yaml
- name: Copy in new default file into sites-available
    copy: 
      src: /home/ubuntu/environment/app/nginx.default 
      dest: /etc/nginx/sites-available/default
    notify: Restart nginx
```
-  Syntax for **installing a package**
```yaml
- name: Install apache httpd
  apt:
    name: apache2
    state: present
```
  - Installing **npm packages**
```yaml
- name: Install pm2
    npm:
      name: pm2
      global: yes
```
  -  How to **create a file** - use file which has many options such as creating links, deleting directories and files and creating files
```yaml
- name: Create files in sites available
  file:
    path: /etc/nginx/sites-available/default.conf
    state: touch
    mode: 666
```
  -  How to **remove a file**
```yaml
- name: Remove old nginx file
    file:
      path: /etc/nginx/sites-available/default
      state: absent
```
  - How to create a **symbolic link**
```yaml
- name: Create a symbolic link 
  file:
    src: /environment/app/nginx.default
    dest: /etc/nginx/sites-available/default
    state: link
```

  - **Reverse proxy with ansible** manually using `blockinfile` which essentially adds a block of text into a file
```yaml
- name: Writing nginx config file reverse proxy
  blockinfile:
    path: /etc/nginx/sites-available/defaut.conf
    block: |
      server{
        listen 80
        server_name
        location / {
              proxy_pass http://127.0.0.1:3000;
        }
      }
```
  - Synchronize is a module which can allow us to sync the folders and files on our machine with another e.g. on aws or vm
```yaml
- name: Sync environment folder
  synchronize:
    src: /home/ubuntu/environment
    dest: /home/ubuntu/
```
### Templates
- The template module can be used to assign variables akin to python OOP polymorphism
- Can replace certain parts of code with {{variable}} which can be whatever we desire
- Template files usually have a `.js` extension i.e. JINJA
```yaml
- hosts: Example
  vars: 
    variable1: 'Good day'
    variable2: 'How are you?'
  tasks:
    - name: Example template
      template:
        src: example_template.j2
        dest: /home/.../Ansible/output.txt
```
- In the `output.txt` can have something like:
```
{{variable1}}
Friend
{{variable2}}
```
- Which will output as:
```
Good day
Friend
How are you?
```

- **Variables**

### How to run pure shell (bash) commands
- Become and become_user allow ansible to run certain commands with greater privilages, akin to using sudo
```yaml
- name:
  become: true
  become_user: ubuntu
  shell: |
    cd ~/
    pwd
    pm2 start app.js
```
