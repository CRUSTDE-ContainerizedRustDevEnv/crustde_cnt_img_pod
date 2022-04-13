#!/usr/bin/env bash

echo "  Bash script to add your SSH keys you use often inside the container."
# The ssh-agent is started already on login inside the ~/.bashrc script.
# Replace the words githubssh1 and webserverssh1 with your file names.

echo "  ssh-add ~/.ssh/githubssh1"
ssh-add ~/.ssh/githubssh1

echo "  ssh-add ~/.ssh/webserverssh1"
ssh-add ~/.ssh/webserverssh1

echo "  ssh-add -L"
ssh-add -L
