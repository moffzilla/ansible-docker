docker
======

This Ansible role enables people to install the latest Docker and Composer on an Ubuntu-like
system. It also provides a handy library function to validate that the Docker
daemon is running and functional.

Requirements
------------

This role will only work on an Ubuntu-like system.

Role Variables
--------------

```yaml
# Any additional docker service options
# Example: '--dns 8.8.8.8 --dns 8.8.4.4 --userns-remap=default'
docker_additional_service_opts: ''
```

Examples
--------

Install this module from Ansible Galaxy into the './roles' directory:

Use it in a playbook as follows:
```yaml
- hosts: 'servers'
  roles:
    - role: 'moffzilla.docker'
      become: true
  tasks:
    - name: 'Ensure that the docker daemon is functional'
      become: true
      docker_ping:
      retries: 5
      delay: 10
      until: result|success
    - name: 'hello world'
      docker:
        name: 'helloworld'
        image: 'hello-world'
        state: 'started'
```
