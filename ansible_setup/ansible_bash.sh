# Install Ansible

sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -Y

# Install python and dependencies 
sudo apt install python3 -y
sudo apt install python3-pip -y
sudo pip install --upgrade pip -y

# Installing 
pip3 install awscli # AWS comman line client ---> Allows direct interaction with AWS via command line
sudo pip3 install boto -y 
sudo pip3 install boto3 -y

# Helper module
sudo apt install tree