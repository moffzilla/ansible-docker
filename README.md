# Ansible-docker
Requirements for the AWS modules are minimal,
however all of the modules require and are tested against recent versions of boto. You’ll need this Python module installed on your control machine. Boto can be installed from your OS distribution or python’s “pip install boto”.

If running inside LXD to AWS
Make sure you do 

  1) Make sure you can SSH locally with ubuntu
  
  2) Disable host checking
      '/etc/ansible/ansible.cfg'
      'host_key_checking = False'
      
  3) Update the Inventory as follows:  
       '/etc/ansible/host'
       'localhost ansible_connection=local'
       
  4) Execute
      'export AWS_ACCESS_KEY_ID=[your key]'
      
      'export AWS_SECRET_ACCESS_KEY=[your secret]'
      
      'ansible-playbook ec2_module.yml -vvvv --user=ubuntu'
