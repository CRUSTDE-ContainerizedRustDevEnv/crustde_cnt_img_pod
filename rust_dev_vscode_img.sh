#!/usr/bin/env bash

echo " "
echo "Bash script to build the docker image for development in Rust with VSCode."
echo "Name of the image: rust_dev_vscode_img"
echo "repository: https://github.com/bestia-dev/docker_rust_development"

echo "Container image for complete Rust development environment with VSCode."
echo "This is based on rust_dev_cargo_img and adds VSCode and extensions."

echo "To build the image, run in bash with:"
echo "sh rust_dev_vscode_img.sh"

echo " "
echo "Removing container and image if exists"
# Be careful, this container is not meant to have persistent data.
# the '|| :' in combination with 'set -e' means that 
# the error is ignored if the container does not exist.
set -e
podman rm rust_dev_vscode_cnt || :
buildah rm rust_dev_vscode_img || :
buildah rmi -f docker.io/bestiadev/rust_dev_vscode_img || :


echo " "
echo "Create new container named rust_dev_vscode_img from rust_dev_cargo_img"
set -o errexit

buildah from --name rust_dev_vscode_img docker.io/bestiadev/rust_dev_cargo_img:cargo-1.60.0

buildah config \
--author=github.com/bestia-dev \
--label name=rust_dev_vscode_img \
--label version=vscode-1.66.2 \
--label source=github.com/bestia-dev/docker_rust_development \
rust_dev_vscode_img

echo " "
echo "The subsequent commands are from user rustdevuser."
echo "If I need, I can add '--user root' to run as root."

echo " "
echo "Prepare directory for public certificates. This is not a secret."
buildah run --user root rust_dev_vscode_img    mkdir -p /home/rustdevuser/.ssh
buildah run --user root rust_dev_vscode_img    chmod 700 /home/rustdevuser/.ssh
buildah run --user root rust_dev_vscode_img    chown -R rustdevuser:rustdevuser /home/rustdevuser/.ssh

echo " "
echo "apk update"
buildah run --user root rust_dev_vscode_img    apt -y update
buildah run --user root rust_dev_vscode_img    apt -y upgrade
buildah run --user root rust_dev_vscode_img    apt -y install openssh-server

echo " "
echo "Download vscode-server. Be sure the commit_sha of the server and client is the same:"
echo "In VSCode client open Help-About or in the terminal 'code --version'" 
echo "version 1.66.2"
echo "dfd34e8260c270da74b5c2d86d61aee4b6d56977"
buildah run rust_dev_vscode_img /bin/sh -c 'mkdir -vp ~/.vscode-server/bin/dfd34e8260c270da74b5c2d86d61aee4b6d56977'
buildah run rust_dev_vscode_img /bin/sh -c 'mkdir -vp ~/.vscode-server/extensions'
buildah run rust_dev_vscode_img /bin/sh -c 'curl -L -s https://update.code.visualstudio.com/commit:dfd34e8260c270da74b5c2d86d61aee4b6d56977/server-linux-x64/stable --output /tmp/vscode-server-linux-x64.tar.gz'
buildah run rust_dev_vscode_img /bin/sh -c 'tar --no-same-owner -xzv --strip-components=1 -C ~/.vscode-server/bin/dfd34e8260c270da74b5c2d86d61aee4b6d56977 -f /tmp/vscode-server-linux-x64.tar.gz'
buildah run rust_dev_vscode_img /bin/sh -c 'rm /tmp/vscode-server-linux-x64.tar.gz'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/dfd34e8260c270da74b5c2d86d61aee4b6d56977/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension streetsidesoftware.code-spell-checker'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/dfd34e8260c270da74b5c2d86d61aee4b6d56977/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension matklad.rust-analyzer'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/dfd34e8260c270da74b5c2d86d61aee4b6d56977/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension davidanson.vscode-markdownlint'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/dfd34e8260c270da74b5c2d86d61aee4b6d56977/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension 2gua.rainbow-brackets'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/dfd34e8260c270da74b5c2d86d61aee4b6d56977/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension dotjoshjohnson.xml'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/dfd34e8260c270da74b5c2d86d61aee4b6d56977/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension serayuzgur.crates'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/dfd34e8260c270da74b5c2d86d61aee4b6d56977/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension bierner.markdown-mermaid'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/dfd34e8260c270da74b5c2d86d61aee4b6d56977/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension ms-vscode.live-server'

echo " "
echo "Remove unwanted files"
buildah run --user root rust_dev_vscode_img    apt -y autoremove
buildah run --user root rust_dev_vscode_img    apt -y clean

echo " "
echo "Finally save/commit the image named rust_dev_vscode_img"
buildah commit rust_dev_vscode_img docker.io/bestiadev/rust_dev_vscode_img:latest

buildah tag docker.io/bestiadev/rust_dev_vscode_img:latest docker.io/bestiadev/rust_dev_vscode_img:vscode-1.66.2
buildah tag docker.io/bestiadev/rust_dev_vscode_img:latest docker.io/bestiadev/rust_dev_vscode_img:cargo-1.60.0

echo " "
echo "  This image is used solely inside the pod 'rust_dev_pod'."
echo "  The command 'sh rust_dev_pod_create.sh' inside the directory '~/rustprojects/docker_rust_development' creates the pod."
