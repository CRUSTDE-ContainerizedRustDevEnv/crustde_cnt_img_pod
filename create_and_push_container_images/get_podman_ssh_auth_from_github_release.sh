#!/bin/sh

printf " \n"
printf "\033[0;33m    Bash script to get the lastest version of ssh_auth_podman_push from GitHub release \033[0m\n"
# repository: https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod

if printf "$PWD\n" | grep -q '/crustde_cnt_img_pod/create_and_push_container_images'; then

    printf "\033[0;33m    Check the newest release: https://github.com/CRUSTDE-ContainerizedRustDevEnv/ssh_auth_podman_push/releases \033[0m\n"
    printf "\033[0;33m    You have to manually search and replace inside this script the current version 1.1.1 to the latest from GitHub!!! \033[0m\n"

    printf "\033[0;32m curl -L https://github.com/CRUSTDE-ContainerizedRustDevEnv/ssh_auth_podman_push/releases/download/v1.1.1/ssh_auth_podman_push-v1.1.1-x86_64-unknown-linux-gnu.tar.gz --output /tmp/ssh_auth_podman_push.tar.gz \033[0m\n"
    curl -L https://github.com/CRUSTDE-ContainerizedRustDevEnv/ssh_auth_podman_push/releases/download/v1.1.1/ssh_auth_podman_push-v1.1.1-x86_64-unknown-linux-gnu.tar.gz --output /tmp/ssh_auth_podman_push.tar.gz

    printf "\033[0;32m tar --no-same-owner -xzv --strip-components=2 -C ./ -f /tmp/ssh_auth_podman_push.tar.gz \033[0m\n"
    tar --no-same-owner -xzv --strip-components=2 -C ./ -f /tmp/ssh_auth_podman_push.tar.gz

    printf "\033[0;32m chmod +x ./ssh_auth_podman_push \033[0m\n"
    chmod +x ./ssh_auth_podman_push

    printf "\033[0;33m    Installation of ./ssh_auth_podman_push is completed!  \033[0m\n"

    printf "\033[0;33m    Use it inside the create_and_push_container_images directory.  \033[0m\n"
    printf "\033[0;32m cd ~/rustprojects/crustde_cnt_img_pod/create_and_push_container_images \033[0m\n"
    printf "\033[0;32m ./ssh_auth_podman_push registry/user_name/image_name:image_label  \033[0m\n"
    printf " "

else
    printf " \n"
    printf "\033[0;31m    You are not in the correct directory ~/rustprojects/crustde_cnt_img_pod/create_and_push_container_images \033[0m\n"
    printf "\033[0;33m    Run the script as:  \033[0m\n"
    printf "\033[0;32m cd ~/rustprojects/crustde_cnt_img_pod/create_and_push_container_images \033[0m\n"
    printf "\033[0;32m sh get_ssh_auth_podman_push_from_github_release.sh \033[0m\n"
fi
