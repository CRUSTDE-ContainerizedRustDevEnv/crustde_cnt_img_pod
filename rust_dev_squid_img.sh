#!/usr/bin/env bash

echo " "
echo "Bash script to build the docker image for the Squid proxy server"
echo "Name of the image: rust_dev_squid_img"
echo "repository: https://github.com/bestia-dev/docker_rust_development"

echo "Squid proxy for restricting outbound network access of containers in the same 'pod'."
echo "Modifies the squid.conf file of the official Squid image."
echo "This container is used inside a Podman 'pod' with the container rust_dev_vscode_img"

echo "To build the image, run in bash with:"
echo "sh rust_dev_squid_img.sh"

echo " "
echo "removing container and image if exists"
# Be careful, this container is not meant to have persistent data.
# the '|| :' in combination with 'set -e' means that 
# the error is ignored if the container does not exist.
set -e
podman rm -f rust_dev_squid_cnt || :
buildah rm rust_dev_squid_img || :
buildah rmi -f docker.io/bestiadev/rust_dev_squid_img || :

echo " "
echo "Create new container named rust_dev_squid_img from sameersbn/squid:latest"
set -o errexit
buildah from \
--name rust_dev_squid_img \
docker.io/sameersbn/squid:3.5.27-2

buildah config \
--author=github.com/bestia-dev \
--label name=rust_dev_squid_img \
--label version=1.0 \
--label source=github.com/bestia-dev/docker_rust_development \
rust_dev_squid_img

echo " "
echo "Copy squid.conf"
buildah copy rust_dev_squid_img 'etc_squid_squid.conf' '/etc/squid/squid.conf'

echo " "
echo "Remove unwanted files"
buildah run --user root rust_dev_squid_img    apt -y autoremove
buildah run --user root rust_dev_squid_img    apt -y clean

echo " "
echo "Finally save/commit the image named rust_dev_squid_img"
buildah commit rust_dev_squid_img docker.io/bestiadev/rust_dev_squid_img:latest

buildah tag docker.io/bestiadev/rust_dev_squid_img:latest docker.io/bestiadev/rust_dev_squid_img:squid-3.5.27-2

echo " "
echo " To create the 'pod' with 'rust_dev_squid_cnt' and 'rust_dev_vscode_cnt' use:"
echo "podman pod create --name rust_dev_pod_create"
echo "podman pod ls"
echo "podman create --name rust_dev_squid_cnt --pod=rust_dev_pod_create -ti --restart=always docker.io/bestiadev/rust_dev_squid_img:latest"
echo "podman start rust_dev_squid_cnt"
echo "podman create --name rust_dev_vscode_cnt --pod=rust_dev_pod_create -ti rust_dev_vscode_img"
echo "podman start rust_dev_vscode_cnt"

echo " "
echo " Firstly: attach VSCode to the running container."
echo "Open VSCode, press F1, type 'attach' and choose 'Remote-Containers:Attach to Running container...' and type rust_dev_vscode_cnt" 
echo " This will open a new VSCode windows attached to the container."
echo " If needed Open VSCode terminal with Ctrl+J"
echo " Inside VSCode terminal, try the if the proxy restrictions work:"
echo "curl --proxy 127.0.0.1:3128 http://httpbin.org/ip"
echo "curl --proxy 127.0.0.1:3128 http://google.com"
