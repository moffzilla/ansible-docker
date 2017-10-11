# Ansible-docker

This is a simple playbook for Provisioning an AWS instance and Installing Docker-CE and compatible Docker Compose
as described in Docker Documentation, inlcuding recommended packages. 

Requirements / Tested :

  ansible 2.1.1.0
  
  Python 2.7.12+
  
  Amazon Web Services Library boto3 & AWS CLI 
 
   You’ll need AWS CLI & this Python module installed on your control machine. Boto can be installed from your OS distribution or python’s using the pip command, install the AWS CLI and Boto3:

   'pip install awscli boto3 -U --ignore-installed six'”.
   
  AWS AIM Credentials with enough rigths for launching VMS and of course, if you reference a resource in AWS, such as a Security Group, make sure that the SG exists and it is properly configured, etc. 
  
Make sure you do:

  1) Make sure you can SSH locally with ubuntu
    (you may need to add your pub key content into the '~/.ssh/authorized_keys')
  
  2) Disable host checking
      '/etc/ansible/ansible.cfg'
      'host_key_checking = False'
      
  3) Update the Inventory as follows:  
       '/etc/ansible/host'
       'localhost ansible_connection=local'
  
  4) Install the 'moffzilla.docker' AKA 'ADC' Role 
  
  ansible-galaxy install -r requirements.yml
  
( More information at https://github.com/moffzilla/ADC )

       
  4) Execute (Generic)
  
      'export AWS_ACCESS_KEY_ID=[your key]'
      
      'export AWS_SECRET_ACCESS_KEY=[your secret]'
      
      'ansible-playbook ec2_module.yml -vvvv --user=ubuntu'
    
    Wait for the plays to complete

  4.1) Deploy an Atomic host ( useful for testing OpenShift Origins containerized )

      'export AWS_ACCESS_KEY_ID=[your key]'

      'export AWS_SECRET_ACCESS_KEY=[your secret]'

      'ansible-playbook ec2_module-openshift.yml -vvvv --user=fedora'

    Wait for the plays to complete 

    If you want to test containerized run OpenShift origins increase the size of the Logical Volume by login (with fedora user) and running

	'sudo lvextend -l +100%FREE atomicos/docker-root-lv'

    You can test you have enough size by pulling the OpenShift docker image 

	'docker pull openshift/origin'
	
	If succesful you can follow the Installing and Starting an All-in-One Server
	
	$ sudo docker run -d --name "origin" \
        --privileged --pid=host --net=host \
        -v /:/rootfs:ro -v /var/run:/var/run:rw -v /sys:/sys -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
        -v /var/lib/docker:/var/lib/docker:rw \
        -v /var/lib/origin/openshift.local.volumes:/var/lib/origin/openshift.local.volumes:rslave \ 
        openshift/origin start
	
	This command:

	starts OpenShift Origin listening on all interfaces on your host (0.0.0.0:8443),

	starts the web console listening on all interfaces at /console (0.0.0.0:8443),

	launches an etcd server to store persistent data, and launches the Kubernetes system components.
	
	More information at :
	
	https://docs.openshift.org/latest/getting_started/administrators.html#try-it-out
	
	http://www.projectatomic.io/docs/docker-storage-recommendation/
	
	https://spin.atomicobject.com/2011/02/24/resizing-lvm-volumes-on-a-virtual-linux-host-without-reboot/
	
    
   5) To terminate any AWS Instance created
    (it requires you to have installed aws cli)
    
    A) To remove all the Machines execute Script
    
    './terminate_all_instances.py' 
    
    B) To remove an specific machine execute Script
    
    './list_instances.py'
    
    './terminate_instances.py [instance-id]'
    
    C) Manually by AWS CLI
    
    'aws ec2 describe-instances | grep InstanceId'
    
    'aws ec2 terminate-instances --instance-ids [i-id]'
    
    
    

