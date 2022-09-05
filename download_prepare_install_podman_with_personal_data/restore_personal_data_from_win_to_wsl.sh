#!/usr/bin/env bash

echo " "
echo "\033[0;33m    Bash script to restore personal data from windows to WSL2 \033[0m"

# restore_personal_data_from_win_to_WSL.sh
# repository: https://github.com/bestia-dev/docker_rust_development

# The backup of personal data could survive the reset of the WSL2 virtual machine.
# Restore will copy it to Debian in ~/.ssh
# Later the 'rust_dev_pod_create.sh' will copy this file from Debian into the newly created container.

setx.exe WSLENV "USERPROFILE/p"
echo $USERPROFILE/.ssh/githubssh1

cp -v $USERPROFILE/.ssh/ ~/.ssh/ 
