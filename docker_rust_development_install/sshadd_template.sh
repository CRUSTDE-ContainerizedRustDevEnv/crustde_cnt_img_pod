#!/bin/sh

echo "   Bash script to add your primary SSH keys to ssh_agent."
# The ssh-agent is started already on login inside the ~/.bashrc script.
# Replace the words github_com_ssh_1 and bestia_dev_ssh_1 with your file names.
# The keys are restricted only to explicit servers/hosts in the ~/.ssh/config file.
# The keys will expire in 1 hour.

# add if key not yet exists
ssh-add -l |grep -q `ssh-keygen -lf ~/.ssh/github_com_ssh_1 | awk '{print $2}'` || ssh-add -t 1h ~/.ssh/github_com_ssh_1

# add if key not yet exists
ssh-add -l |grep -q `ssh-keygen -lf ~/.ssh/bestia_dev_ssh_1 | awk '{print $2}'` || ssh-add -t 1h ~/.ssh/bestia_dev_ssh_1

echo "   List public fingerprints inside ssh-agent:"
echo "   ssh-add -l"
ssh-add -l

echo " "
