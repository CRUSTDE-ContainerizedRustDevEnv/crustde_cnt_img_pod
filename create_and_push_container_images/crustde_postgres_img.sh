#!/bin/sh

printf " \n"
printf "\033[0;33m    Bash script to build the docker image for the postgres database server \033[0m\n"
printf "\033[0;33m    Name of the image: crustde_postgres_img \033[0m\n"
# repository: https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod

printf "\033[0;33m    postgres image on docker hub has 8 layers. \033[0m\n"
printf "\033[0;33m    I don't know if this is too much and affects performance, \033[0m\n"
printf "\033[0;33m    but I will squash it to one single layer. \033[0m\n"

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
printf "\033[0;33m    Create new 'buildah container' named crustde_postgres_img from sameersbn/postgres:latest \033[0m\n"
set -o errexit
buildah from \
--name crustde_postgres_img \
docker.io/library/postgres:15

printf "\033[0;33m    podman image tree docker.io/library/postgres:15 \033[0m\n"
podman image tree docker.io/library/postgres:15

buildah config \
--author=github.com/bestia-dev \
--label name=crustde_postgres_img \
--label version=postgres15 \
--label source=github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod \
crustde_postgres_img

printf " \n"
printf "\033[0;33m    Remove unwanted files \033[0m\n"
buildah run --user root crustde_postgres_img    apt -y autoremove
buildah run --user root crustde_postgres_img    apt -y clean

printf " \n"
printf "\033[0;33m    Finally save/commit the image named crustde_postgres_img \033[0m\n"
buildah commit --squash crustde_postgres_img docker.io/bestiadev/crustde_postgres_img:latest

buildah tag docker.io/bestiadev/crustde_postgres_img:latest docker.io/bestiadev/crustde_postgres_img:postgres15

printf " \n"
printf "\033[0;33m    Upload the new image to docker hub. \033[0m\n"
printf "\033[0;32m ./ssh_auth_podman_push docker.io/bestiadev/crustde_postgres_img:postgres15 \033[0m\n"
printf "\033[0;32m ./ssh_auth_podman_push docker.io/bestiadev/crustde_postgres_img:latest \033[0m\n"

printf " \n"
printf "\033[0;33m    This image is used solely inside the pod 'crustde_pod'. \033[0m\n"
printf "\033[0;33m    Follow the instructions to install the CRUSTDE pod: \033[0m\n"
printf "\033[0;32m https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod \033[0m\n"

printf " \n"
