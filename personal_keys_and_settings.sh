#!/usr/bin/env bash

echo " "
echo "\033[0;33m    Bash script to install personal keys and setting into the Rust development container. \033[0m"

# personal_keys_and_settings.sh
# repository: https://github.com/bestia-dev/docker_rust_development

# This script starts as a template with placeholders.
# First, copy it into the windows folder 'c:\Users\my_user_name\.ssh',
# so it can survive the destruction of the container and WSL2.
# There modify it with your personal data and file_names.
# You need to replace the words: 
# 'info@your.mail', 'your_name', 'githubssh1' and 'webserverssh1'
# with you personal data and file_names.
# Warning: Once modified, don't share this file with anyone and don't push it to Github, because it will contain your data.

# The 'rust_dev_pod_create.sh' will copy this file from Windows into WSL2.

echo " "
echo "\033[0;33m    Set git personal information inside the container \033[0m"
echo "\033[0;33m    podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global user.email 'info@your.mail' \033[0m"
podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global user.email "info@your.mail"
echo "\033[0;33m    podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global user.name 'your_name' \033[0m"
podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global user.name "your_name"
echo "\033[0;33m    podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global -l \033[0m"
podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global -l

setx.exe WSLENV "USERPROFILE/p"
echo $USERPROFILE/.ssh/githubssh1

echo " "
echo "\033[0;33m    Copy the private and public keys for github and to 'publish to web' \033[0m"
echo "\033[0;33m    from windows persistent folder 'c:\Users\my_user_name\.ssh' \033[0m"
echo "\033[0;33m    to the ephemeral folder '~/.ssh' in WSL, that can be destroyed any time. \033[0m"

echo "\033[0;33m    cp -v $USERPROFILE/.ssh/githubssh1 ~/.ssh/githubssh1 \033[0m"
cp -v $USERPROFILE/.ssh/githubssh1 ~/.ssh/githubssh1
echo "\033[0;33m    chmod 600 ~/.ssh/githubssh1 \033[0m"
chmod 600 ~/.ssh/githubssh1
echo "\033[0;33m    cp -v $USERPROFILE/.ssh/githubssh1.pub ~/.ssh/githubssh1.pub \033[0m"
cp -v $USERPROFILE/.ssh/githubssh1.pub ~/.ssh/githubssh1.pub

echo "\033[0;33m    cp -v $USERPROFILE/.ssh/webserverssh1 ~/.ssh/webserverssh1 \033[0m"
cp -v $USERPROFILE/.ssh/webserverssh1 ~/.ssh/webserverssh1
echo "\033[0;33m    chmod 600 ~/.ssh/webserverssh1 \033[0m"
chmod 600 ~/.ssh/webserverssh1
echo "\033[0;33m    cp -v $USERPROFILE/.ssh/webserverssh1.pub ~/.ssh/webserverssh1.pub \033[0m"
cp -v $USERPROFILE/.ssh/webserverssh1.pub ~/.ssh/webserverssh1.pub

echo " "
echo "\033[0;33m    Copy the private and public keys for github and to 'publish to web' \033[0m"
echo "\033[0;33m    from the '~/.ssh' in WSL into the container. \033[0m"

echo "\033[0;33m    podman exec --user=rustdevuser rust_dev_vscode_cnt ls -l /home/rustdevuser/.ssh \033[0m"
podman exec --user=rustdevuser rust_dev_vscode_cnt ls -l /home/rustdevuser/.ssh

echo "\033[0;33m    podman cp ~/.ssh/githubssh1 rust_dev_vscode_cnt:/home/rustdevuser/.ssh/githubssh1 \033[0m"
podman cp ~/.ssh/githubssh1 rust_dev_vscode_cnt:/home/rustdevuser/.ssh/githubssh1
echo "\033[0;33m    podman exec --user=rustdevuser rust_dev_vscode_cnt chmod 600 /home/rustdevuser/.ssh/githubssh1 \033[0m"
podman exec --user=rustdevuser rust_dev_vscode_cnt chmod 600 /home/rustdevuser/.ssh/githubssh1
echo "\033[0;33m    podman cp ~/.ssh/githubssh1.pub rust_dev_vscode_cnt:/home/rustdevuser/.ssh/githubssh1.pub \033[0m"
podman cp ~/.ssh/githubssh1.pub rust_dev_vscode_cnt:/home/rustdevuser/.ssh/githubssh1.pub

echo "\033[0;33m    podman cp ~/.ssh/webserverssh1 rust_dev_vscode_cnt:/home/rustdevuser/.ssh/webserverssh1 \033[0m"
podman cp ~/.ssh/webserverssh1 rust_dev_vscode_cnt:/home/rustdevuser/.ssh/webserverssh1
echo "\033[0;33m    podman exec --user=rustdevuser rust_dev_vscode_cnt chmod 600 /home/rustdevuser/.ssh/webserverssh1 \033[0m"
podman exec --user=rustdevuser rust_dev_vscode_cnt chmod 600 /home/rustdevuser/.ssh/webserverssh1
echo "\033[0;33m    podman cp ~/.ssh/webserverssh1.pub rust_dev_vscode_cnt:/home/rustdevuser/.ssh/webserverssh1.pub \033[0m"
podman cp ~/.ssh/webserverssh1.pub rust_dev_vscode_cnt:/home/rustdevuser/.ssh/webserverssh1.pub

echo "\033[0;33m    podman exec --user=rustdevuser rust_dev_vscode_cnt ls -l /home/rustdevuser/.ssh \033[0m"
podman exec --user=rustdevuser rust_dev_vscode_cnt ls -l /home/rustdevuser/.ssh

echo  \033[0m"\033[0;33m    Copy the 'sshadd.sh' from Win10 to WSL and then into the container"
cp -v $USERPROFILE/.ssh/sshadd.sh ~/.ssh/sshadd.sh
podman cp ~/.ssh/sshadd.sh rust_dev_vscode_cnt:/home/rustdevuser/.ssh/sshadd.sh
