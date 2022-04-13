#!/usr/bin/env bash

echo " "
echo "  Bash script to start the agent and add the SSH keys we use often inside the container."
echo "  sshadd.sh"
echo " " 
echo "  repository: https://github.com/bestia-dev/docker_rust_development"
echo " " 
echo "  This is a template. You need to replace the words 'githubssh1' and 'webserverssh1' to match your personal files."
echo "  And then save this bash script in Win10 in the persistent folder '~\.ssh'"
echo "  "
echo "  The 'rust_dev_pod_create.sh' will copy this file from Windows into WSL2 and then into the container."
echo "  If the copied files do not yet exist, you can copy it manually:"
echo "  setx.exe WSLENV 'USERPROFILE/p'"
echo "  cp -v \$USERPROFILE/.ssh/sshadd.sh ~/.ssh/sshadd.sh"
echo "  podman cp ~/.ssh/sshadd.sh rust_dev_vscode_cnt:/home/rustdevuser/.ssh/sshadd.sh"

echo "  "
echo "  eval \$(ssh-agent)"
eval $(ssh-agent)

echo "  ssh-add ~/.ssh/githubssh1"
ssh-add ~/.ssh/githubssh1

echo "  ssh-add ~/.ssh/webserverssh1"
ssh-add ~/.ssh/webserverssh1

echo "  ssh-add list"
ssh-add list