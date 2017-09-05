# Ansible-docker

This is a simple playbook for Provisioning an AWS instance and Installing Docker and Compose on top 

Requirements for the AWS modules are minimal,
however all of the modules require and are tested against recent versions of boto. You’ll need this Python module installed on your control machine. Boto can be installed from your OS distribution or python’s “pip install boto”.

Make sure you do:

  1) Make sure you can SSH locally with ubuntu
    ( you may need to add your pub key content into the '~/.ssh/authorized_keys' )
  
  2) Disable host checking
      '/etc/ansible/ansible.cfg'
      'host_key_checking = False'
      
  3) Update the Inventory as follows:  
       '/etc/ansible/host'
       'localhost ansible_connection=local'
  
  4) Install the following Roles:
  
  ansible-galaxy install franklinkim.docker
  ansible-galaxy install franklinkim.docker-compose
  
  ( check the following links for details
  https://github.com/weareinteractive/ansible-docker
  https://galaxy.ansible.com/franklinkim/docker-compose/ )
       
  4) Execute
      'export AWS_ACCESS_KEY_ID=[your key]'
      
      'export AWS_SECRET_ACCESS_KEY=[your secret]'
      
      'ansible-playbook ec2_module.yml -vvvv --user=ubuntu'

