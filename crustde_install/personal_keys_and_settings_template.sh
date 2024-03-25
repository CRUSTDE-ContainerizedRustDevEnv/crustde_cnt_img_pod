#!/bin/sh

echo " "
echo "\033[0;33m    Bash script to install personal keys and setting into CRUSTDE - Containerized Rust Development Environment. \033[0m"

# personal_keys_and_settings_template.sh
# repository: https://github.com/CRUSTDE-Containerized-Rust-Dev-Env/crustde_cnt_img_pod

# This script starts as a template with placeholders.
# The script store_personal_keys_and_settings.sh copies it into the Linux folder '~\.ssh' and rename it to "personal_keys_and_settings.sh".
# Then it replace the words: 
# 'info@your.mail', 'your_gitname', 'github_com_git_ssh_1', 'your_webserver', 'your_username'
# with you personal data and file_names.
# Warning: Once modified, don't share this file with anyone and don't push it to GitHub because it will contain your data.
# Copy this data into Windows folder. So it will be persistent also in the event that the WSL2 is reset.

echo " "
echo "\033[0;33m    Set git personal information inside the container \033[0m"
echo "\033[0;33m    podman exec --user=rustdevuser crustde_vscode_cnt git config --global user.email 'info@your.mail' \033[0m"
podman exec --user=rustdevuser crustde_vscode_cnt git config --global user.email "info@your.mail"
echo "\033[0;33m    podman exec --user=rustdevuser crustde_vscode_cnt git config --global user.name 'your_gitname' \033[0m"
podman exec --user=rustdevuser crustde_vscode_cnt git config --global user.name "your_gitname"
echo "\033[0;33m    podman exec --user=rustdevuser crustde_vscode_cnt git config --global -l \033[0m"
podman exec --user=rustdevuser crustde_vscode_cnt git config --global -l

echo "\033[0;33m    podman exec --user=rustdevuser crustde_vscode_cnt ls -la /home/rustdevuser/.ssh \033[0m"
podman exec --user=rustdevuser crustde_vscode_cnt ls -la /home/rustdevuser/.ssh

echo "\033[0;33m    podman cp ~/.ssh/github_com_git_ssh_1 crustde_vscode_cnt:/home/rustdevuser/.ssh/github_com_git_ssh_1 \033[0m"
podman cp ~/.ssh/github_com_git_ssh_1 crustde_vscode_cnt:/home/rustdevuser/.ssh/github_com_git_ssh_1
echo "\033[0;33m    podman exec --user=rustdevuser crustde_vscode_cnt chmod 600 /home/rustdevuser/.ssh/github_com_git_ssh_1 \033[0m"
podman exec --user=rustdevuser crustde_vscode_cnt chmod 600 /home/rustdevuser/.ssh/github_com_git_ssh_1
echo "\033[0;33m    podman cp ~/.ssh/github_com_git_ssh_1.pub crustde_vscode_cnt:/home/rustdevuser/.ssh/github_com_git_ssh_1.pub \033[0m"
podman cp ~/.ssh/github_com_git_ssh_1.pub crustde_vscode_cnt:/home/rustdevuser/.ssh/github_com_git_ssh_1.pub

echo "\033[0;33m    podman cp ~/.ssh/your_key_for_webserver_ssh_1 crustde_vscode_cnt:/home/rustdevuser/.ssh/your_key_for_webserver_ssh_1 \033[0m"
podman cp ~/.ssh/your_key_for_webserver_ssh_1 crustde_vscode_cnt:/home/rustdevuser/.ssh/your_key_for_webserver_ssh_1
echo "\033[0;33m    podman exec --user=rustdevuser crustde_vscode_cnt chmod 600 /home/rustdevuser/.ssh/your_key_for_webserver_ssh_1 \033[0m"
podman exec --user=rustdevuser crustde_vscode_cnt chmod 600 /home/rustdevuser/.ssh/your_key_for_webserver_ssh_1
echo "\033[0;33m    podman cp ~/.ssh/your_key_for_webserver_ssh_1.pub crustde_vscode_cnt:/home/rustdevuser/.ssh/your_key_for_webserver_ssh_1.pub \033[0m"
podman cp ~/.ssh/your_key_for_webserver_ssh_1.pub crustde_vscode_cnt:/home/rustdevuser/.ssh/your_key_for_webserver_ssh_1.pub

echo "\033[0;33m    podman exec --user=rustdevuser crustde_vscode_cnt ls -la /home/rustdevuser/.ssh \033[0m"
podman exec --user=rustdevuser crustde_vscode_cnt ls -la /home/rustdevuser/.ssh

echo "\033[0;33m    Copy the '~/.ssh/crustde_pod_keys/sshadd.sh' from Debian into the container \033[0m"
podman cp ~/.ssh/crustde_pod_keys/sshadd.sh crustde_vscode_cnt:/home/rustdevuser/.ssh/sshadd.sh

echo "\033[0;33m    Copy the '~/.ssh/crustde_pod_keys/config' from Debian into the container \033[0m"
podman cp ~/.ssh/crustde_pod_keys/config crustde_vscode_cnt:/home/rustdevuser/.ssh/config
podman exec --user=rustdevuser crustde_vscode_cnt chmod 600 /home/rustdevuser/.ssh/config

echo " "
