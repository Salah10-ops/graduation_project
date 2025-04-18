##!/bin/bash
## Check if the Jenkins EC2 instance is up and running
#
#ping -c 4 54.234.185.183 > /dev/null
#
#if [ $? -eq 0 ]; then
#  echo "Jenkins server is reachable, running Ansible playbook..."
#  ansible-playbook -i inventory.ini install_jenkins.yml
#else
#  echo "Jenkins server is not reachable. Exiting."
#  exit 1
#fi
#