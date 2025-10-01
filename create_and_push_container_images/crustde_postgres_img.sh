#!/bin/sh

printf " \n"
printf "\033[0;33m    Bash script to build the docker image for the postgres database server \033[0m\n"
printf "\033[0;33m    The image is created without clusters. They must be created in the entrypoint bash script. \033[0m\n"
printf "\033[0;33m    The entrypoint must be set when 'podman create' the container. \033[0m\n"
printf "\033[0;33m    This is described in 'create_and_push_container_images\postgres_entrypoint.sh' \033[0m\n"
printf "\033[0;33m    Name of the image: crustde_postgres_img \033[0m\n"
# repository: https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod

printf "\033[0;33m    To build the image, run in bash with: \033[0m\n"
printf "\033[0;33m sh crustde_postgres_img.sh \033[0m\n"

printf " \n"
printf "\033[0;33m    removing container and image if exists \033[0m\n"
# Be careful, this container is not meant to have persistent data.
# the '|| :' in combination with 'set -e' means that 
# the error is ignored if the container does not exist.

set -e
podman rm -f crustde_postgres_cnt || :
buildah rm crustde_postgres_img || :
buildah rmi -f docker.io/bestiadev/crustde_postgres_img || :

printf " \n"
printf "\033[0;33m    Create new 'buildah container' named crustde_postgres_img \033[0m\n"
printf "\033[0;33m    Version postgres 17 on Debian 13 (trixie) \033[0m\n"
set -o errexit
buildah from \
--name crustde_postgres_img \
docker.io/library/debian:trixie-slim

buildah config \
--author=github.com/bestia-dev \
--label name=crustde_postgres_img \
--label version=postgres17 \
--label source=github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod \
crustde_postgres_img

printf " \n"
printf "\033[0;33m    Debian apt update and upgrade \033[0m\n"
buildah run crustde_postgres_img    apt -y update
buildah run crustde_postgres_img    apt -y full-upgrade

printf " \n"
printf "\033[0;33m    Install nano, the default easy to use text editor in Debian \033[0m\n"
buildah run crustde_postgres_img    apt -y install nano

printf " \n"
printf "\033[0;33m    Create non-root user 'postgres' the database superuser. \033[0m\n"
buildah run crustde_postgres_img groupadd postgres
buildah run crustde_postgres_img useradd -g postgres -m postgres

printf " \n"
printf "\033[0;33m    Install postgresql-common \033[0m\n"
buildah run crustde_postgres_img    apt -y install postgresql-common
printf "\033[0;33m    I don't want the default cluster to be installed. \033[0m\n"
printf "\033[0;33m    Change the line #create_main_cluster = true to false in /etc/postgresql-common/createcluster.conf \033[0m\n"
buildah run crustde_postgres_img    sed -i 's/#create_main_cluster = true/create_main_cluster = false/g' /etc/postgresql-common/createcluster.conf

printf " \n"
printf "\033[0;33m    Install postgres 17 in debian 13 \033[0m\n"
buildah run crustde_postgres_img    apt -y install postgresql

printf " \n"
printf "\033[0;33m    Remove unwanted files \033[0m\n"
buildah run --user root crustde_postgres_img    apt -y autoremove
buildah run --user root crustde_postgres_img    apt -y clean

buildah config --user postgres crustde_postgres_img
buildah config --workingdir /home/postgres crustde_postgres_img

printf " \n"
printf "\033[0;33m    Finally save/commit the image named crustde_postgres_img \033[0m\n"
buildah commit --squash crustde_postgres_img docker.io/bestiadev/crustde_postgres_img:latest

buildah tag docker.io/bestiadev/crustde_postgres_img:latest docker.io/bestiadev/crustde_postgres_img:postgres17

printf " \n"
printf "\033[0;33m    Upload the new image to docker hub. \033[0m\n"
printf "\033[0;32m chmod +x ~/rustprojects/ssh_auth_podman_push/ssh_auth_podman_push \033[0m\n"
printf "\033[0;32m alias ssh_auth_podman_push='~/rustprojects/ssh_auth_podman_push/ssh_auth_podman_push' \033[0m\n"
printf "\033[0;32m ssh_auth_podman_push docker.io/bestiadev/crustde_postgres_img:postgres17 \033[0m\n"
printf "\033[0;32m ssh_auth_podman_push docker.io/bestiadev/crustde_postgres_img:latest \033[0m\n"

printf " \n"
printf "\033[0;33m    This image is used solely inside the pod 'crustde_pod'. \033[0m\n"
printf "\033[0;33m    Follow the instructions to install the CRUSTDE pod: \033[0m\n"
printf "\033[0;32m https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod \033[0m\n"

printf " \n"
