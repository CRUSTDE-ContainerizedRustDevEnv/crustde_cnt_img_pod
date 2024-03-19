#!/bin/sh

echo " "
echo "\033[0;33m    Bash script to restore personal data from Windows to WSL2 \033[0m"

# TODO: this must be changed and run from the host (Windows)

# restore_personal_data_from_win_to_WSL.sh
# repository: https://github.com/CRUSTDE-Containerized-Rust-Dev-Env/docker_rust_development

# The backup of personal data could survive the reset of the WSL2 virtual machine.
# Restore will copy it to Debian in ~/.ssh
# Later the 'rust_dev_pod_create.sh' will copy this file from Debian into the newly created container.

win_userprofile="$(cmd.exe /c "<nul set /p=%UserProfile%" 2>/dev/null)"
WSLWINUSERPROFILE="$(wslpath $win_userprofile)"
echo $WSLWINUSERPROFILE/.ssh/github_com_git_ssh_1

cp -v $WSLWINUSERPROFILE/.ssh/ ~/.ssh/ 

echo " "
