#!/usr/bin/env bash

echo " "
echo "\033[0;33m    Bash script to build the docker image for development in Rust with VSCode. \033[0m"
echo "\033[0;33m    Name of the image: rust_dev_vscode_img \033[0m"
# repository: https://github.com/bestia-dev/docker_rust_development

echo "\033[0;33m    Container image for complete Rust development environment with VSCode. \033[0m"
echo "\033[0;33m    This is based on rust_dev_cargo_img and adds VSCode and extensions. \033[0m"

echo "\033[0;33m    To build the image, run in bash with: \033[0m"
echo "\033[0;33m sh rust_dev_vscode_img.sh \033[0m"

echo " "
echo "\033[0;33m    Removing container and image if exists \033[0m"
# Be careful, this container is not meant to have persistent data.
# the '|| :' in combination with 'set -e' means that 
# the error is ignored if the container does not exist.
set -e
podman rm rust_dev_vscode_cnt || :
buildah rm rust_dev_vscode_img || :
buildah rmi -f docker.io/bestiadev/rust_dev_vscode_img || :


echo " "
echo "\033[0;33m    Create new 'buildah container' named rust_dev_vscode_img from rust_dev_cargo_img \033[0m"
set -o errexit

buildah from --name rust_dev_vscode_img docker.io/bestiadev/rust_dev_cargo_img:cargo-1.61.0

buildah config \
--author=github.com/bestia-dev \
--label name=rust_dev_vscode_img \
--label version=vscode-1.68.0 \
--label source=github.com/bestia-dev/docker_rust_development \
rust_dev_vscode_img

echo " "
echo "\033[0;33m    The subsequent commands are from user rustdevuser. \033[0m"
echo "\033[0;33m    If I need, I can add '--user root' to run as root. \033[0m"

echo " "
echo "\033[0;33m    Prepare directory for public certificates. This is not a secret. \033[0m"
buildah run --user root rust_dev_vscode_img    mkdir -p /home/rustdevuser/.ssh
buildah run --user root rust_dev_vscode_img    chmod 700 /home/rustdevuser/.ssh
buildah run --user root rust_dev_vscode_img    chown -R rustdevuser:rustdevuser /home/rustdevuser/.ssh

echo " "
echo "\033[0;33m    apk update \033[0m"
buildah run --user root rust_dev_vscode_img    apt -y update
buildah run --user root rust_dev_vscode_img    apt -y upgrade
buildah run --user root rust_dev_vscode_img    apt install -y openssh-server

echo " "
echo "\033[0;33m      Install cargo-auto. It will pull the cargo-index registry. The first pull can take some time. \033[0m"
buildah run rust_dev_vscode_img /bin/sh -c 'cargo install cargo-auto'

echo " "
echo "\033[0;33m    Download vscode-server. Be sure the commit_sha of the server and client is the same: \033[0m"
echo "\033[0;33m    In VSCode client open Help-About or in the terminal 'code --version' \033[0m" 
echo "\033[0;33m    version 1.68.0 \033[0m"
echo "\033[0;33m    4af164ea3a06f701fe3e89a2bcbb421d2026b68f \033[0m"
buildah run rust_dev_vscode_img /bin/sh -c 'mkdir -vp ~/.vscode-server/bin/4af164ea3a06f701fe3e89a2bcbb421d2026b68f'
buildah run rust_dev_vscode_img /bin/sh -c 'mkdir -vp ~/.vscode-server/extensions'
buildah run rust_dev_vscode_img /bin/sh -c 'curl -L -s https://update.code.visualstudio.com/commit:4af164ea3a06f701fe3e89a2bcbb421d2026b68f/server-linux-x64/stable --output /tmp/vscode-server-linux-x64.tar.gz'
buildah run rust_dev_vscode_img /bin/sh -c 'tar --no-same-owner -xzv --strip-components=1 -C ~/.vscode-server/bin/4af164ea3a06f701fe3e89a2bcbb421d2026b68f -f /tmp/vscode-server-linux-x64.tar.gz'
buildah run rust_dev_vscode_img /bin/sh -c 'rm /tmp/vscode-server-linux-x64.tar.gz'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/4af164ea3a06f701fe3e89a2bcbb421d2026b68f/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension streetsidesoftware.code-spell-checker'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/4af164ea3a06f701fe3e89a2bcbb421d2026b68f/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension rust-lang.rust-analyzer'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/4af164ea3a06f701fe3e89a2bcbb421d2026b68f/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension davidanson.vscode-markdownlint'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/4af164ea3a06f701fe3e89a2bcbb421d2026b68f/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension 2gua.rainbow-brackets'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/4af164ea3a06f701fe3e89a2bcbb421d2026b68f/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension dotjoshjohnson.xml'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/4af164ea3a06f701fe3e89a2bcbb421d2026b68f/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension serayuzgur.crates'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/4af164ea3a06f701fe3e89a2bcbb421d2026b68f/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension ms-vscode.live-server'

echo " "
echo "\033[0;33m    Remove unwanted files \033[0m"
buildah run --user root rust_dev_vscode_img    apt -y autoremove
buildah run --user root rust_dev_vscode_img    apt -y clean

echo " "
echo "\033[0;33m    Finally save/commit the image named rust_dev_vscode_img \033[0m"
buildah commit rust_dev_vscode_img docker.io/bestiadev/rust_dev_vscode_img:latest

buildah tag docker.io/bestiadev/rust_dev_vscode_img:latest docker.io/bestiadev/rust_dev_vscode_img:vscode-1.68.0
buildah tag docker.io/bestiadev/rust_dev_vscode_img:latest docker.io/bestiadev/rust_dev_vscode_img:cargo-1.61.0

echo " "
echo "\033[0;33m    This image is used solely inside the pod 'rust_dev_pod'. \033[0m"
echo "\033[0;33m    The command 'sh rust_dev_pod_create.sh' inside the directory '~/rustprojects/docker_rust_development' creates the pod. \033[0m"
