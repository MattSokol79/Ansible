# Packer
An AMI creating tool

## Installing packer in bash/Linux/AWS instance
- Following HashiCorp instructions

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt-get update && sudo apt-get install packer
```

## Creating a packer template
- Follow hashicorps instructions for creating the template:

```json
{
  "variables": {
    "aws_access_key": "",
    "aws_secret_key": ""
  },
  "builders": [
    {
      "type": "amazon-ebs",
      "access_key": "{{user `aws_access_key`}}",
      "secret_key": "{{user `aws_secret_key`}}",
      "region": "eu-west-1",
      "source_ami_filter": {
        "filters": {
          "virtualization-type": "hvm",
          "name": "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*",
          "root-device-type": "ebs"
        },
        "owners": ["099720109477"],
        "most_recent": true
      },
      "instance_type": "t2.micro",
      "ssh_username": "ubuntu",
      "ami_name": "eng74-matt-ami-packer"
    }
  ]
}
```
- To validate the file works -> `packer validate <file_name>` (No errors == everything works)

- Will need to utilise the ansible vault for aws keys -> Need to specify these into `~/.bashrc` with `echo "export AWS_ACCESS_KEY=..... >> ~/.bashrc` same for the secret key. Make sure to run the bashrc to update -> `.~/.bashrc` 
- Then we can input these variables into the packer code above -->
```json
{
  "variables": {
  "aws_access_key": "{{env `AWS_ACCESS_KEY`}}",
  "aws_secret_key": "{{env `AWS_SECRET_KEY`}}"
```
- Then run the packer `packer build example.json` --> This creates the AMI image which can be seen on AWS under AMIs

## Provisioning with Playbooks
- We need to add in provisioners to the end of builders which essentially runs the playbooks to setup the app within the AMI
```json
"provisioners": [
    {
      "type": "ansible",
      "playbook_file": "/home/ubuntu/playbooks/app_setup.yaml"
    }
  ]
```
- NOTE - The AMI does not have hosts so will need to specify localhost in the playbook
```yaml
hosts: default
```
- Ensure update and software-properties-common is ran in the playbook before anything else to install all the modules required. 

### Full code of packer file
```json
{
  "variables": {
    "aws_access_key": "{{env `AWS_ACCESS_KEY`}}",
    "aws_secret_key": "{{env `AWS_SECRET_KEY`}}"
  },
  "builders": [
    {
      "type": "amazon-ebs",
      "access_key": "{{user `aws_access_key`}}",
      "secret_key": "{{user `aws_secret_key`}}",
      "region": "eu-west-1",
      "source_ami_filter": {
        "filters": {
          "virtualization-type": "hvm",
          "name": "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*",
          "root-device-type": "ebs"
        },
        "owners": ["099720109477"],
        "most_recent": true
      },
      "instance_type": "t2.micro",
      "ssh_username": "ubuntu",
      "ami_name": "eng74-matt-ami-packer-app4"
    }
  ],

  "provisioners": [
    {
      "type": "ansible",
      "playbook_file": "/home/ubuntu/playbooks/app_setup.yaml"
    }
  ]
}
```