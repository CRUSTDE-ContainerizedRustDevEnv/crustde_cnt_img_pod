#!/bin/sh
# ~/.ssh/crustde_pod_keys/personal_keys_and_settings.sh

printf " \n"
printf "\033[0;33m  Bash script to install personal keys and settings into a new CRUSTDE - Containerized Rust Development Environment. \033[0m\n"
printf " \n"

# repository: https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod

# This script starts as a template with placeholders.
# The script store_personal_keys_and_settings.sh copies it into the Linux folder '~\.ssh\crustde_pod_keys' 
# and renames it to "personal_keys_and_settings.sh".
# Then it replace the words: 
# 'info@your.mail', 'your_git_name', 'your_key_for_github_ssh_1', 'your_webserver', 'your_username', 'your_key_for_webserver_ssh_1', 'your_key_for_github_api_token_ssh_1'
# with you personal data and file_names.
# Warning: Once modified, don't share this file with anyone and don't push it to GitHub because it will contain your data.
# Backup the WSL/Debian folder ~/.ssh into the Windows folder "C:\Users\username\.ssh\wsl_ssh_backup". 
# So it will be persistent also in the event that the WSL2 is completely reset.
# This will simplify the next creation of a new CRUSTDE container/pod.

printf "\033[0;33m  First copy (if newer) the 2 important private/public keys from ~/.ssh into ~/.ssh/crustde_pod_keys \033[0m\n"
printf "\033[0;33m  cp -u ~/.ssh/your_key_for_github_ssh_1 ~/.ssh/crustde_pod_keys/your_key_for_github_ssh_1 \033[0m\n"
cp -u ~/.ssh/your_key_for_github_ssh_1 ~/.ssh/crustde_pod_keys/your_key_for_github_ssh_1
printf "\033[0;33m  cp -u ~/.ssh/your_key_for_github_ssh_1.pub ~/.ssh/crustde_pod_keys/your_key_for_github_ssh_1.pub \033[0m\n"
cp -u ~/.ssh/your_key_for_github_ssh_1.pub ~/.ssh/crustde_pod_keys/your_key_for_github_ssh_1.pub
printf "\033[0;33m  cp -u ~/.ssh/your_key_for_webserver_ssh_1 ~/.ssh/crustde_pod_keys/your_key_for_webserver_ssh_1 \033[0m\n"
cp -u ~/.ssh/your_key_for_webserver_ssh_1 ~/.ssh/crustde_pod_keys/your_key_for_webserver_ssh_1
printf "\033[0;33m  cp -u ~/.ssh/your_key_for_webserver_ssh_1.pub ~/.ssh/crustde_pod_keys/your_key_for_webserver_ssh_1.pub \033[0m\n"
cp -u ~/.ssh/your_key_for_webserver_ssh_1.pub ~/.ssh/crustde_pod_keys/your_key_for_webserver_ssh_1.pub
printf " \n"

printf "\033[0;33m  If there are more private/public keys that you need, you can copy them manually into the folder ~/.ssh/crustde_pod_keys \033[0m\n"

printf " \n"
printf "\033[0;33m  Set git personal information inside the container \033[0m\n"
printf "\033[0;33m  podman exec --user=rustdevuser crustde_vscode_cnt git config --global user.email 'info@your.mail' \033[0m\n"
podman exec --user=rustdevuser crustde_vscode_cnt git config --global user.email "info@your.mail"
printf "\033[0;33m  podman exec --user=rustdevuser crustde_vscode_cnt git config --global user.name 'your_git_name' \033[0m\n"
podman exec --user=rustdevuser crustde_vscode_cnt git config --global user.name "your_git_name"
printf "\033[0;33m  podman exec --user=rustdevuser crustde_vscode_cnt git config --global -l \033[0m\n"
podman exec --user=rustdevuser crustde_vscode_cnt git config --global -l

printf "\033[0;33m  podman exec --user=rustdevuser crustde_vscode_cnt ls -la /home/rustdevuser/.ssh \033[0m\n"
podman exec --user=rustdevuser crustde_vscode_cnt ls -la /home/rustdevuser/.ssh

# Loop through the .pub files and copy all the key files into the container.
printf "\n"
printf "\033[33m  List identities inside ~/.ssh/crustde_pod_keys and copy to container:  \033[0m\n"
printf "\n"
for entry in ~/.ssh/crustde_pod_keys/*.pub 
do
  # remove suffix .pub
  full_file_name=${entry%.pub}
  # echo "$full_file_name"
  # remove all characters except slash slashes
  only_slashes="$(echo $full_file_name | sed 's#[^/]##g')"
  # echo "$only_slashes"
  # count slashes
  num_of_slashes=${#only_slashes}
  # echo $num_of_slashes
  last_slash=$((num_of_slashes + 1))
  # echo $last_slash
  # remove prefix until the last slash
  file_name=$(echo $full_file_name |  cut -d '/' -f $last_slash )
  # echo "$file_name"

  printf "\033[0;33m  $file_name \033[0m\n"
  printf "\033[0;33m  podman cp ~/.ssh/crustde_pod_keys/$file_name crustde_vscode_cnt:/home/rustdevuser/.ssh/$file_name \033[0m\n"
  podman cp ~/.ssh/crustde_pod_keys/$file_name crustde_vscode_cnt:/home/rustdevuser/.ssh/$file_name
  printf "\033[0;33m  podman exec --user=rustdevuser crustde_vscode_cnt chmod 600 /home/rustdevuser/.ssh/$file_name \033[0m\n"
  podman exec --user=rustdevuser crustde_vscode_cnt chmod 600 /home/rustdevuser/.ssh/$file_name

  printf "\033[0;33m  podman cp ~/.ssh/crustde_pod_keys/$file_name.pub crustde_vscode_cnt:/home/rustdevuser/.ssh/$file_name.pub \033[0m\n"
  podman cp ~/.ssh/crustde_pod_keys/$file_name.pub crustde_vscode_cnt:/home/rustdevuser/.ssh/$file_name.pub

  # if exist copy the .enc file
  if [ -f ~/.ssh/crustde_pod_keys/$file_name.enc ]; then
    printf "\033[0;33m  podman cp ~/.ssh/crustde_pod_keys/$file_name.enc crustde_vscode_cnt:/home/rustdevuser/.ssh/$file_name.enc \033[0m\n"
    podman cp ~/.ssh/crustde_pod_keys/$file_name.enc crustde_vscode_cnt:/home/rustdevuser/.ssh/$file_name.enc
  fi
  printf "\n"
done

# other files to copy
printf "\033[0;33m  podman exec --user=rustdevuser crustde_vscode_cnt ls /home/rustdevuser/.ssh \033[0m\n"
podman exec --user=rustdevuser crustde_vscode_cnt ls /home/rustdevuser/.ssh

printf "\033[0;33m  Copy the '~/.ssh/crustde_pod_keys/sshadd.sh' from Debian into the container \033[0m\n"
podman cp ~/.ssh/crustde_pod_keys/sshadd.sh crustde_vscode_cnt:/home/rustdevuser/.ssh/sshadd.sh

printf "\033[0;33m  Copy the '~/.ssh/crustde_pod_keys/config' from Debian into the container \033[0m\n"
podman cp ~/.ssh/crustde_pod_keys/config crustde_vscode_cnt:/home/rustdevuser/.ssh/config
podman exec --user=rustdevuser crustde_vscode_cnt chmod 600 /home/rustdevuser/.ssh/config

printf " \n"
