#!/bin/sh

echo " "
echo "\033[0;33m    Bash script to install personal keys and setting into the Rust development container. \033[0m"

# personal_keys_and_settings_template.sh
# repository: https://github.com/bestia-dev/docker_rust_development

# This script starts as a template with placeholders.
# The script store_personal_keys_and_settings.sh copies it into the Linux folder '~\.ssh' and rename it to "personal_keys_and_settings.sh".
# Then it replace the words: 
# 'info@your.mail', 'your_name', 'githubssh1' and 'webserverssh1'
# with you personal data and file_names.
# Warning: Once modified, don't share this file with anyone and don't push it to Github, because it will contain your data.
# Use the backup_personal_data_from_wsl_to_win.sh to backup this data into windows folder. So it will be persistent also in 
# the event that the WSL2 is reset.

echo " "
echo "\033[0;33m    Set git personal information inside the container \033[0m"
echo "\033[0;33m    podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global user.email 'info@your.mail' \033[0m"
podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global user.email "info@your.mail"
echo "\033[0;33m    podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global user.name 'your_name' \033[0m"
podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global user.name "your_name"
echo "\033[0;33m    podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global -l \033[0m"
podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global -l

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

echo "\033[0;33m    Copy the 'sshadd.sh' from Debian into the container\033[0m"
podman cp ~/.ssh/sshadd.sh rust_dev_vscode_cnt:/home/rustdevuser/.ssh/sshadd.sh
