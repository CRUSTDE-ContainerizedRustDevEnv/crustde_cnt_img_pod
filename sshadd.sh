#!/usr/bin/env bash

echo "   Bash script to add your primary SSH keys to ssh_agent."
# The ssh-agent is started already on login inside the ~/.bashrc script.
# Replace the words githubssh1 and webserverssh1 with your file names.

# add if key not yet exists
ssh-add -l |grep -q `ssh-keygen -lf ~/.ssh/githubssh1 | awk '{print $2}'` || ssh-add ~/.ssh/githubssh1

# add if key not yet exists
ssh-add -l |grep -q `ssh-keygen -lf ~/.ssh/webserverssh1 | awk '{print $2}'` || ssh-add ~/.ssh/webserverssh1

echo "   List public fingerprints inside ssh-agent:"
echo "   ssh-add -l"
ssh-add -l

