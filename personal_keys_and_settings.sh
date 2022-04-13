#!/usr/bin/env bash

echo " "
echo "  Bash script to install personal keys and setting into the Rust development container."
echo "  personal_keys_and_settings.sh"
echo " "
echo "  repository: https://github.com/bestia-dev/docker_rust_development"
echo " " 
echo "  This script starts as a template with placeholders."
echo "  First, copy it into the windows folder 'c:\Users\my_user_name\.ssh',"
echo "  so it can survive the destruction of the container and WSL2."
echo "  There modify it with your personal data and file_names."
echo "  You need to replace the words: "
echo "  'info@your.mail', 'your_name', 'githubssh1' and 'webserverssh1'"
echo "  with you personal data and file_names."
echo "  Warning: Once modified, don't share this file with anyone and don't push it to Github, because it will contain your data."
echo " "
echo "  The 'podman_install_and_setup.sh' will copy this file from Windows into WSL2."
echo "  If the copied file does not yet exist, you can copy it manually:"
echo "  setx.exe WSLENV 'USERPROFILE/p'"
echo "  cp -v \$USERPROFILE/.ssh/personal_keys_and_settings.sh ~/.ssh/personal_keys_and_settings.sh"
echo "  Run it from WSL2 terminal:"
echo "  sh ~/.ssh/personal_keys_and_settings.sh"

echo " "
echo "  Set git personal information inside the container"
echo "  podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global user.email 'info@your.mail'"
podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global user.email "info@your.mail"
echo "  podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global user.name 'your_name'"
podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global user.name "your_name"
echo "  podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global -l"
podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global -l

setx.exe WSLENV "USERPROFILE/p"
echo $USERPROFILE/.ssh/githubssh1

echo " "
echo "  Copy the private and public keys for github and to 'publish to web'"
echo "  from windows persistent folder 'c:\Users\my_user_name\.ssh'"
echo "  to the ephemeral folder '~/.ssh' in WSL, that can be destroyed any time."

echo "  cp -v $USERPROFILE/.ssh/githubssh1 ~/.ssh/githubssh1"
cp -v $USERPROFILE/.ssh/githubssh1 ~/.ssh/githubssh1
echo "  chmod 600 ~/.ssh/githubssh1"
chmod 600 ~/.ssh/githubssh1
echo "  cp -v $USERPROFILE/.ssh/githubssh1.pub ~/.ssh/githubssh1.pub"
cp -v $USERPROFILE/.ssh/githubssh1.pub ~/.ssh/githubssh1.pub

echo "  cp -v $USERPROFILE/.ssh/webserverssh1 ~/.ssh/webserverssh1"
cp -v $USERPROFILE/.ssh/webserverssh1 ~/.ssh/webserverssh1
echo "  chmod 600 ~/.ssh/webserverssh1"
chmod 600 ~/.ssh/webserverssh1
echo "  cp -v $USERPROFILE/.ssh/webserverssh1.pub ~/.ssh/webserverssh1.pub"
cp -v $USERPROFILE/.ssh/webserverssh1.pub ~/.ssh/webserverssh1.pub

echo " "
echo "  Copy the private and public keys for github and to 'publish to web'"
echo "  from the '~/.ssh' in WSL into the container."

echo "  podman exec --user=rustdevuser rust_dev_vscode_cnt ls -l /home/rustdevuser/.ssh"
podman exec --user=rustdevuser rust_dev_vscode_cnt ls -l /home/rustdevuser/.ssh

echo "  podman cp ~/.ssh/githubssh1 rust_dev_vscode_cnt:/home/rustdevuser/.ssh/githubssh1"
podman cp ~/.ssh/githubssh1 rust_dev_vscode_cnt:/home/rustdevuser/.ssh/githubssh1
echo "  podman exec --user=rustdevuser rust_dev_vscode_cnt chmod 600 /home/rustdevuser/.ssh/githubssh1"
podman exec --user=rustdevuser rust_dev_vscode_cnt chmod 600 /home/rustdevuser/.ssh/githubssh1
echo "  podman cp ~/.ssh/githubssh1.pub rust_dev_vscode_cnt:/home/rustdevuser/.ssh/githubssh1.pub"
podman cp ~/.ssh/githubssh1.pub rust_dev_vscode_cnt:/home/rustdevuser/.ssh/githubssh1.pub

echo "  podman cp ~/.ssh/webserverssh1 rust_dev_vscode_cnt:/home/rustdevuser/.ssh/webserverssh1"
podman cp ~/.ssh/webserverssh1 rust_dev_vscode_cnt:/home/rustdevuser/.ssh/webserverssh1
echo "  podman exec --user=rustdevuser rust_dev_vscode_cnt chmod 600 /home/rustdevuser/.ssh/webserverssh1"
podman exec --user=rustdevuser rust_dev_vscode_cnt chmod 600 /home/rustdevuser/.ssh/webserverssh1
echo "  podman cp ~/.ssh/webserverssh1.pub rust_dev_vscode_cnt:/home/rustdevuser/.ssh/webserverssh1.pub"
podman cp ~/.ssh/webserverssh1.pub rust_dev_vscode_cnt:/home/rustdevuser/.ssh/webserverssh1.pub

echo "  podman exec --user=rustdevuser rust_dev_vscode_cnt ls -l /home/rustdevuser/.ssh"
podman exec --user=rustdevuser rust_dev_vscode_cnt ls -l /home/rustdevuser/.ssh

echo "  Copy the 'sshadd.sh' from Win10 to WSL and then into the container"
cp -v $USERPROFILE/.ssh/sshadd.sh ~/.ssh/sshadd.sh
podman cp ~/.ssh/sshadd.sh rust_dev_vscode_cnt:/home/rustdevuser/.ssh/sshadd.sh
