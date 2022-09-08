#!/bin/sh

# README:

echo " "
echo "\033[0;33m    Bash script to build the docker image for development in Rust with VSCode and typescript. \033[0m"
echo "\033[0;33m    Name of the image: rust_ts_dev_vscode_img \033[0m"
# repository: https://github.com/bestia-dev/docker_rust_development

echo "\033[0;33m    Container image for complete Rust development environment with VSCode and typescript. \033[0m"
echo "\033[0;33m    This is based on rust_dev_vscode_img and adds Typescript. \033[0m"

echo " "
echo "\033[0;33m    FIRST !!! \033[0m"
echo "\033[0;33m    Search and replace in this bash script: \033[0m"
echo "\033[0;33m    Version of rustc: 1.63.0 \033[0m"
echo "\033[0;33m    Version of vscode: 1.71.0 \033[0m"
echo "\033[0;33m    Version of typescript: 4.7.4 \033[0m"

echo "\033[0;33m    To build the image, run in bash with: \033[0m"
echo "\033[0;33m sh rust_ts_dev_vscode_img.sh \033[0m"

# Start of script actions:

echo " "
echo "\033[0;33m    Removing container and image if exists \033[0m"
# Be careful, this container is not meant to have persistent data.
# the '|| :' in combination with 'set -e' means that 
# the error is ignored if the container does not exist.
set -e
podman rm rust_ts_dev_vscode_cnt || :
buildah rm rust_ts_dev_vscode_img || :
buildah rmi -f docker.io/bestiadev/rust_ts_dev_vscode_img || :


echo " "
echo "\033[0;33m    Create new 'buildah container' named rust_ts_dev_vscode_img from rust_dev_vscode_img \033[0m"
set -o errexit

buildah from --name rust_ts_dev_vscode_img docker.io/bestiadev/rust_dev_vscode_img:vscode-1.71.0

buildah config \
--author=github.com/bestia-dev \
--label name=rust_ts_dev_vscode_img \
--label version=typescript-4.7.4 \
--label source=github.com/bestia-dev/docker_rust_development \
rust_ts_dev_vscode_img

echo " "
echo "\033[0;33m    The subsequent commands are from user rustdevuser. \033[0m"
echo "\033[0;33m    If I need, I can add '--user root' to run as root. \033[0m"

echo " "
echo "\033[0;33m    apk update \033[0m"
buildah run --user root rust_ts_dev_vscode_img    apt -y update
buildah run --user root rust_ts_dev_vscode_img    apt -y upgrade

echo " "
echo "\033[0;33m    typescript compiler, nodejs, npm \033[0m"
buildah run --user root rust_ts_dev_vscode_img    apt install -y nodejs npm 
echo "\033[0;33m    node -v \033[0m"
buildah run --user root rust_ts_dev_vscode_img    node -v
# on 2022-07-19 is v12.22.12
echo "\033[0;33m    npm -v \033[0m"
buildah run --user root rust_ts_dev_vscode_img    npm -v
# on 2022-07-19 is 7.5.2
buildah run --user root rust_ts_dev_vscode_img    npm install -g typescript
echo "\033[0;33m    tsc --version \033[0m"
buildah run --user root rust_ts_dev_vscode_img    tsc --version
# on 2022-07-19 is 4.7.4

echo " "
echo "\033[0;33m    Remove unwanted files \033[0m"
buildah run --user root rust_ts_dev_vscode_img    apt -y autoremove
buildah run --user root rust_ts_dev_vscode_img    apt -y clean

echo " "
echo "\033[0;33m    Finally save/commit the image named rust_ts_dev_vscode_img \033[0m"
buildah commit rust_ts_dev_vscode_img docker.io/bestiadev/rust_ts_dev_vscode_img:latest

buildah tag docker.io/bestiadev/rust_ts_dev_vscode_img:latest docker.io/bestiadev/rust_ts_dev_vscode_img:typescript-4.7.4
buildah tag docker.io/bestiadev/rust_ts_dev_vscode_img:latest docker.io/bestiadev/rust_ts_dev_vscode_img:vscode-1.71.0
buildah tag docker.io/bestiadev/rust_ts_dev_vscode_img:latest docker.io/bestiadev/rust_ts_dev_vscode_img:cargo-1.63.0

echo " "
echo "\033[0;33m    Upload the new image to docker hub. \033[0m"
echo "\033[0;33m    First you need to store the credentials with: \033[0m"
echo "\033[0;32m podman login --username bestiadev docker.io \033[0m"
echo "\033[0;33m    then type docker access token. \033[0m"
echo "\033[0;32m podman push docker.io/bestiadev/rust_ts_dev_vscode_img:typescript-4.7.4 \033[0m"
echo "\033[0;32m podman push docker.io/bestiadev/rust_ts_dev_vscode_img:vscode-1.71.0 \033[0m"
echo "\033[0;32m podman push docker.io/bestiadev/rust_dev_vscode_img:cargo-1.63.0 \033[0m"
echo "\033[0;32m podman push docker.io/bestiadev/rust_dev_vscode_img:latest \033[0m"

echo " "
echo "\033[0;33m    This image is used solely inside the pod 'rust_dev_pod'. \033[0m"
echo "\033[0;33m    The command 'sh rust_dev_pod_create.sh' inside the directory '~/rustprojects/docker_rust_development' creates the pod. \033[0m"
echo " "