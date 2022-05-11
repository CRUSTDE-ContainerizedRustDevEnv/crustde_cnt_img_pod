#!/usr/bin/env bash

echo " "
echo "Bash script to build the docker image for development in Rust with VSCode and typescript."
echo "Name of the image: rust_dev_typescript_img"
# repository: https://github.com/bestia-dev/docker_rust_development"

echo "Container image for complete Rust development environment with VSCode and typescript."
echo "This is based on rust_dev_vscode_img and adds VSCode and extensions."

echo "To build the image, run in bash with:"
echo "sh rust_dev_typescript_img.sh"

echo " "
echo "Removing container and image if exists"
# Be careful, this container is not meant to have persistent data.
# the '|| :' in combination with 'set -e' means that 
# the error is ignored if the container does not exist.
set -e
podman rm rust_dev_typescript_cnt || :
buildah rm rust_dev_typescript_img || :
buildah rmi -f docker.io/bestiadev/rust_dev_typescript_img || :


echo " "
echo "Create new container named rust_dev_typescript_img from rust_dev_vscode_img"
set -o errexit

buildah from --name rust_dev_typescript_img docker.io/bestiadev/rust_dev_vscode_img:vscode-1.67.1

buildah config \
--author=github.com/bestia-dev \
--label name=rust_dev_typescript_img \
--label version=typescript-4.6.4 \
--label source=github.com/bestia-dev/docker_rust_development \
rust_dev_typescript_img

echo " "
echo "The subsequent commands are from user rustdevuser."
echo "If I need, I can add '--user root' to run as root."

echo " "
echo "apk update"
buildah run --user root rust_dev_typescript_img    apt -y update
buildah run --user root rust_dev_typescript_img    apt -y upgrade

echo " "
echo "typescript compiler, nodejs, npm"
buildah run --user root rust_dev_typescript_img    apt install -y nodejs npm 
buildah run --user root rust_dev_typescript_img    node -v
buildah run --user root rust_dev_typescript_img    npm -v
buildah run --user root rust_dev_typescript_img    npm install -g typescript
buildah run --user root rust_dev_typescript_img    tsc --version

echo " "
echo "Remove unwanted files"
buildah run --user root rust_dev_typescript_img    apt -y autoremove
buildah run --user root rust_dev_typescript_img    apt -y clean

echo " "
echo "Finally save/commit the image named rust_dev_typescript_img"
buildah commit rust_dev_typescript_img docker.io/bestiadev/rust_dev_typescript_img:latest

buildah tag docker.io/bestiadev/rust_dev_typescript_img:latest docker.io/bestiadev/rust_dev_typescript_img:typescript-4.6.4
buildah tag docker.io/bestiadev/rust_dev_typescript_img:latest docker.io/bestiadev/rust_dev_typescript_img:vscode-1.67.1
buildah tag docker.io/bestiadev/rust_dev_typescript_img:latest docker.io/bestiadev/rust_dev_typescript_img:cargo-1.60.0
