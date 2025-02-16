#!/bin/sh

printf " \n"
printf "\033[0;33m    Bash script to install personal keys and setting into CRUSTDE - Containerized Rust Development Environment. \033[0m\n"

# personal_keys_and_settings_template.sh
# repository: https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod

# This script starts as a template with placeholders.
# The script store_personal_keys_and_settings.sh copies it into the Linux folder '~\.ssh' and rename it to "personal_keys_and_settings.sh".
# Then it replace the words: 
# 'info@your.mail', 'your_git_name', 'your_key_for_github_ssh_1', 'your_webserver', 'your_username', 'your_key_for_webserver_ssh_1', 'your_key_for_github_api_token_ssh_1'
# with you personal data and file_names.
# Warning: Once modified, don't share this file with anyone and don't push it to GitHub because it will contain your data.
# Copy this data into Windows folder. So it will be persistent also in the event that the WSL2 is reset.

printf " \n"
printf "\033[0;33m    Set git personal information inside the container \033[0m\n"
printf "\033[0;33m    podman exec --user=rustdevuser crustde_vscode_cnt git config --global user.email 'info@your.mail' \033[0m\n"
podman exec --user=rustdevuser crustde_vscode_cnt git config --global user.email "info@your.mail"
printf "\033[0;33m    podman exec --user=rustdevuser crustde_vscode_cnt git config --global user.name 'your_git_name' \033[0m\n"
podman exec --user=rustdevuser crustde_vscode_cnt git config --global user.name "your_git_name"
printf "\033[0;33m    podman exec --user=rustdevuser crustde_vscode_cnt git config --global -l \033[0m\n"
podman exec --user=rustdevuser crustde_vscode_cnt git config --global -l

printf "\033[0;33m    podman exec --user=rustdevuser crustde_vscode_cnt ls -la /home/rustdevuser/.ssh \033[0m\n"
podman exec --user=rustdevuser crustde_vscode_cnt ls -la /home/rustdevuser/.ssh

printf "\033[0;33m    Copy your_key_for_github_ssh_1 \033[0m\n"
printf "\033[0;33m    podman cp ~/.ssh/your_key_for_github_ssh_1 crustde_vscode_cnt:/home/rustdevuser/.ssh/your_key_for_github_ssh_1 \033[0m\n"
podman cp ~/.ssh/your_key_for_github_ssh_1 crustde_vscode_cnt:/home/rustdevuser/.ssh/your_key_for_github_ssh_1
printf "\033[0;33m    podman exec --user=rustdevuser crustde_vscode_cnt chmod 600 /home/rustdevuser/.ssh/your_key_for_github_ssh_1 \033[0m\n"
podman exec --user=rustdevuser crustde_vscode_cnt chmod 600 /home/rustdevuser/.ssh/your_key_for_github_ssh_1
printf "\033[0;33m    podman cp ~/.ssh/your_key_for_github_ssh_1.pub crustde_vscode_cnt:/home/rustdevuser/.ssh/your_key_for_github_ssh_1.pub \033[0m\n"
podman cp ~/.ssh/your_key_for_github_ssh_1.pub crustde_vscode_cnt:/home/rustdevuser/.ssh/your_key_for_github_ssh_1.pub

printf "\033[0;33m    Copy your_key_for_webserver_ssh_1 \033[0m\n"
printf "\033[0;33m    podman cp ~/.ssh/your_key_for_webserver_ssh_1 crustde_vscode_cnt:/home/rustdevuser/.ssh/your_key_for_webserver_ssh_1 \033[0m\n"
podman cp ~/.ssh/your_key_for_webserver_ssh_1 crustde_vscode_cnt:/home/rustdevuser/.ssh/your_key_for_webserver_ssh_1
printf "\033[0;33m    podman exec --user=rustdevuser crustde_vscode_cnt chmod 600 /home/rustdevuser/.ssh/your_key_for_webserver_ssh_1 \033[0m\n"
podman exec --user=rustdevuser crustde_vscode_cnt chmod 600 /home/rustdevuser/.ssh/your_key_for_webserver_ssh_1
printf "\033[0;33m    podman cp ~/.ssh/your_key_for_webserver_ssh_1.pub crustde_vscode_cnt:/home/rustdevuser/.ssh/your_key_for_webserver_ssh_1.pub \033[0m\n"
podman cp ~/.ssh/your_key_for_webserver_ssh_1.pub crustde_vscode_cnt:/home/rustdevuser/.ssh/your_key_for_webserver_ssh_1.pub

printf "\033[0;33m    Copy your_key_for_github_api_token_ssh_1 \033[0m\n"
printf "\033[0;33m    podman cp ~/.ssh/your_key_for_github_api_token_ssh_1 crustde_vscode_cnt:/home/rustdevuser/.ssh/your_key_for_github_api_token_ssh_1 \033[0m\n"
podman cp ~/.ssh/your_key_for_github_api_token_ssh_1 crustde_vscode_cnt:/home/rustdevuser/.ssh/your_key_for_github_api_token_ssh_1
printf "\033[0;33m    podman exec --user=rustdevuser crustde_vscode_cnt chmod 600 /home/rustdevuser/.ssh/your_key_for_github_api_token_ssh_1 \033[0m\n"
podman exec --user=rustdevuser crustde_vscode_cnt chmod 600 /home/rustdevuser/.ssh/your_key_for_github_api_token_ssh_1
printf "\033[0;33m    podman cp ~/.ssh/your_key_for_github_api_token_ssh_1.pub crustde_vscode_cnt:/home/rustdevuser/.ssh/your_key_for_github_api_token_ssh_1.pub \033[0m\n"
podman cp ~/.ssh/your_key_for_github_api_token_ssh_1.pub crustde_vscode_cnt:/home/rustdevuser/.ssh/your_key_for_github_api_token_ssh_1.pub
printf "\033[0;33m    podman cp ~/.ssh/your_key_for_github_api_token_ssh_1.enc crustde_vscode_cnt:/home/rustdevuser/.ssh/your_key_for_github_api_token_ssh_1.enc \033[0m\n"
podman cp ~/.ssh/your_key_for_github_api_token_ssh_1.enc crustde_vscode_cnt:/home/rustdevuser/.ssh/your_key_for_github_api_token_ssh_1.enc
printf "\033[0;33m    podman exec --user=rustdevuser crustde_vscode_cnt chmod 600 /home/rustdevuser/.ssh/your_key_for_github_api_token_ssh_1.enc \033[0m\n"
podman exec --user=rustdevuser crustde_vscode_cnt chmod 600 /home/rustdevuser/.ssh/your_key_for_github_api_token_ssh_1.enc

printf "\033[0;33m    podman exec --user=rustdevuser crustde_vscode_cnt ls -la /home/rustdevuser/.ssh \033[0m\n"
podman exec --user=rustdevuser crustde_vscode_cnt ls -la /home/rustdevuser/.ssh

printf "\033[0;33m    Copy the '~/.ssh/crustde_pod_keys/sshadd.sh' from Debian into the container \033[0m\n"
podman cp ~/.ssh/crustde_pod_keys/sshadd.sh crustde_vscode_cnt:/home/rustdevuser/.ssh/sshadd.sh

printf "\033[0;33m    Copy the '~/.ssh/crustde_pod_keys/config' from Debian into the container \033[0m\n"
podman cp ~/.ssh/crustde_pod_keys/config crustde_vscode_cnt:/home/rustdevuser/.ssh/config
podman exec --user=rustdevuser crustde_vscode_cnt chmod 600 /home/rustdevuser/.ssh/config

printf " \n"
