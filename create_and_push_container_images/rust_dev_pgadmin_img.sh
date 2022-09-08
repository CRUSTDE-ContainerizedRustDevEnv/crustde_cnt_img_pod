#!/bin/sh

echo " "
echo "\033[0;33m    Bash script to build the docker image for the pgadmin server \033[0m"
echo "\033[0;33m    Name of the image: rust_dev_pgadmin_img \033[0m"
# repository: https://github.com/bestia-dev/docker_rust_development

echo "\033[0;33m    pgadmin image on docker hub has 14 layers. \033[0m"
echo "\033[0;33m    I don't know if this is too much and affects performance, \033[0m"
echo "\033[0;33m    but I will squash it to one single layer. \033[0m"

echo "\033[0;33m    To build the image, run in bash with: \033[0m"
echo "\033[0;33m sh rust_dev_pgadmin_img.sh \033[0m"

echo " "
echo "\033[0;33m    removing container and image if exists \033[0m"
# Be careful, this container is not meant to have persistent data.
# the '|| :' in combination with 'set -e' means that 
# the error is ignored if the container does not exist.

set -e
podman rm -f rust_dev_pgadmin_cnt || :
buildah rm rust_dev_pgadmin_img || :
buildah rmi -f docker.io/bestiadev/rust_dev_pgadmin_img || :

echo " "
echo "\033[0;33m    Create new 'buildah container' named rust_dev_pgadmin_img from docker.io/dpage/pgadmin4:latest \033[0m"
set -o errexit
buildah from \
--name rust_dev_pgadmin_img \
docker.io/dpage/pgadmin4:latest

echo "\033[0;33m    podman image tree docker.io/dpage/pgadmin4:latest \033[0m"
podman image tree docker.io/dpage/pgadmin4:latest

buildah config \
--author=github.com/bestia-dev \
--label name=rust_dev_pgadmin_img \
--label version=pgadmin4 \
--label source=github.com/bestia-dev/docker_rust_development \
rust_dev_pgadmin_img

# echo " "
# echo "\033[0;33m    Remove unwanted files \033[0m"
# buildah run --user root rust_dev_pgadmin_img    apt-get -y autoremove
# buildah run --user root rust_dev_pgadmin_img    apt-get -y clean


echo " "
echo "\033[0;33m    Finally save/commit the image named rust_dev_pgadmin_img \033[0m"
buildah commit --squash rust_dev_pgadmin_img docker.io/bestiadev/rust_dev_pgadmin_img:latest

buildah tag docker.io/bestiadev/rust_dev_pgadmin_img:latest docker.io/bestiadev/rust_dev_pgadmin_img:pgadmin4

echo " "
echo "\033[0;33m    Upload the new image to docker hub. \033[0m"
echo "\033[0;33m    First you need to store the credentials with: \033[0m"
echo "\033[0;32m podman login --username bestiadev docker.io \033[0m"
echo "\033[0;33m    then type docker access token. \033[0m"
echo "\033[0;32m podman push docker.io/bestiadev/rust_dev_pgadmin_img:pgadmin4 \033[0m"
echo "\033[0;32m podman push docker.io/bestiadev/rust_dev_pgadmin_img:latest \033[0m"

echo " "