#!/bin/sh

echo " "
echo "\033[0;33m    Bash script to build the docker image for the postgres database server \033[0m"
echo "\033[0;33m    Name of the image: rust_dev_postgres_img \033[0m"
# repository: https://github.com/CRUSTDE-Containerized-Rust-Dev-Env/docker_rust_development

echo "\033[0;33m    postgres image on docker hub has 8 layers. \033[0m"
echo "\033[0;33m    I don't know if this is too much and affects performance, \033[0m"
echo "\033[0;33m    but I will squash it to one single layer. \033[0m"

echo "\033[0;33m    To build the image, run in bash with: \033[0m"
echo "\033[0;33m sh rust_dev_postgres_img.sh \033[0m"

echo " "
echo "\033[0;33m    removing container and image if exists \033[0m"
# Be careful, this container is not meant to have persistent data.
# the '|| :' in combination with 'set -e' means that 
# the error is ignored if the container does not exist.

set -e
podman rm -f rust_dev_postgres_cnt || :
buildah rm rust_dev_postgres_img || :
buildah rmi -f docker.io/bestiadev/rust_dev_postgres_img || :

echo " "
echo "\033[0;33m    Create new 'buildah container' named rust_dev_postgres_img from sameersbn/postgres:latest \033[0m"
set -o errexit
buildah from \
--name rust_dev_postgres_img \
docker.io/library/postgres:13

echo "\033[0;33m    podman image tree docker.io/library/postgres:13 \033[0m"
podman image tree docker.io/library/postgres:13

buildah config \
--author=github.com/bestia-dev \
--label name=rust_dev_postgres_img \
--label version=postgres13 \
--label source=github.com/CRUSTDE-Containerized-Rust-Dev-Env/docker_rust_development \
rust_dev_postgres_img

echo " "
echo "\033[0;33m    Remove unwanted files \033[0m"
buildah run --user root rust_dev_postgres_img    apt -y autoremove
buildah run --user root rust_dev_postgres_img    apt -y clean

echo " "
echo "\033[0;33m    Finally save/commit the image named rust_dev_postgres_img \033[0m"
buildah commit --squash rust_dev_postgres_img docker.io/bestiadev/rust_dev_postgres_img:latest

buildah tag docker.io/bestiadev/rust_dev_postgres_img:latest docker.io/bestiadev/rust_dev_postgres_img:postgres13

echo " "
echo "\033[0;33m    Upload the new image to docker hub. \033[0m"
echo "\033[0;33m    First you need to store the credentials with: \033[0m"
echo "\033[0;32m podman login --username bestiadev docker.io \033[0m"
echo "\033[0;33m    then type docker access token. \033[0m"
echo "\033[0;32m podman push docker.io/bestiadev/rust_dev_postgres_img:postgres13 \033[0m"
echo "\033[0;32m podman push docker.io/bestiadev/rust_dev_postgres_img:latest \033[0m"

echo " "