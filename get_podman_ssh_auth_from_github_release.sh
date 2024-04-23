#!/bin/sh

printf " \n"
printf "\033[0;33m    Bash script to get the lastest version of podman_ssh_auth from GitHub release \033[0m\n"
printf "\033[0;33m    Run the script as: sh get_podman_ssh_auth_from_github_release.sh \033[0m\n"
# repository: https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod

printf "\033[0;33m    Check the newest release: https://github.com/CRUSTDE-ContainerizedRustDevEnv/podman_ssh_auth/releases \033[0m\n"
printf "\033[0;33m    You have to manually change the version of the release inside this script!!! \033[0m\n"

printf "\033[0;32m curl -L https://github.com/CRUSTDE-ContainerizedRustDevEnv/podman_ssh_auth/releases/download/v1.0.4/podman_ssh_auth-v1.0.4-x86_64-unknown-linux-gnu.tar.gz --output /tmp/podman_ssh_auth.tar.gz \033[0m\n"
curl -L https://github.com/CRUSTDE-ContainerizedRustDevEnv/podman_ssh_auth/releases/download/v1.0.4/podman_ssh_auth-v1.0.4-x86_64-unknown-linux-gnu.tar.gz --output /tmp/podman_ssh_auth.tar.gz

printf "\033[0;32m tar --no-same-owner -xzv --strip-components=2 -C create_and_push_container_images/ -f /tmp/podman_ssh_auth.tar.gz \033[0m\n"
tar --no-same-owner -xzv --strip-components=2 -C create_and_push_container_images/ -f /tmp/podman_ssh_auth.tar.gz

printf "\033[0;32m chmod +x create_and_push_container_images/podman_ssh_auth \033[0m\n"
chmod +x create_and_push_container_images/podman_ssh_auth

printf "\033[0;33m    Installation of create_and_push_container_images/podman_ssh_auth is completed!  \033[0m\n"

printf "\033[0;33m    Use it inside the create_and_push_container_images directory.  \033[0m\n"
printf "\033[0;32m cd create_and_push_container_images  \033[0m\n"
printf "\033[0;32m ./podman_ssh_auth push registry/user_name/image_name:image_label  \033[0m\n"
printf " "
