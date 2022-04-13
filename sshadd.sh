#!/usr/bin/env bash

echo " "
echo "  Bash script to start the agent and add the SSH keys we use often inside the container."
echo "  sshadd.sh"
echo " "
echo "  This is a template. You need to modify the filenames to your personal files."
echo "  And then save this bash script in Win10 in the persistent folder '~\.ssh'"
echo "  repository: https://github.com/bestia-dev/docker_rust_development"
echo " " 

echo "eval \$(ssh-agent)"
eval $(ssh-agent)

echo "ssh-add ~/.ssh/githubssh1"
ssh-add ~/.ssh/githubssh1

echo "ssh-add ~/.ssh/webserverssh1"
ssh-add ~/.ssh/webserverssh1