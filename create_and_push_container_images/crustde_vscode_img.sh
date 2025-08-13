#!/bin/sh

# README:

printf " \n"
printf "\033[0;33m    Bash script to build the docker image for development in Rust with VSCode. \033[0m\n"
printf "\033[0;33m    Name of the image: crustde_vscode_img \033[0m\n"
# repository: https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod

printf "\033[0;33m    Container image for CRUSTDE - Containerized Rust Development Environment with VSCode. \033[0m\n"
printf "\033[0;33m    This is based on crustde_cross_img and adds VSCode and extensions. \033[0m\n"

printf " \n"
printf "\033[0;33m    FIRST !!! \033[0m\n"
printf "\033[0;33m    Search and replace in this bash script: \033[0m\n"
printf "\033[0;33m    Version of rustc: 1.89.0 \033[0m\n"
printf "\033[0;33m    Version of vscode: 1.103.0 \033[0m\n"
printf "\033[0;33m    Commit hash of VSCode: e3550cfac4b63ca4eafca7b601f0d2885817fd1f \033[0m\n"

printf "\033[0;33m    To build the image, run in bash with: \033[0m\n"
printf "\033[0;33m sh crustde_vscode_img.sh \033[0m\n"

# Start of script actions:

printf " \n"
printf "\033[0;33m    Removing container and image if exists \033[0m\n"
# Be careful, this container is not meant to have persistent data.
# the '|| :' in combination with 'set -e' means that 
# the error is ignored if the container does not exist.
set -e
podman rm crustde_vscode_cnt || :
buildah rm crustde_vscode_img || :
buildah rmi -f docker.io/bestiadev/crustde_vscode_img || :

printf " \n"
printf "\033[0;33m    Create new 'buildah container' named crustde_vscode_img from crustde_cross_img \033[0m\n"
set -o errexit

buildah from \
--name crustde_vscode_img \
docker.io/bestiadev/crustde_cross_img:cargo-1.89.0

buildah config \
--author=github.com/bestia-dev \
--label name=crustde_vscode_img \
--label version=vscode-1.103.0 \
--label source=github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod \
crustde_vscode_img

printf " \n"
printf "\033[0;33m    The subsequent commands are from user rustdevuser. \033[0m\n"
printf "\033[0;33m    If I need, I can add '--user root' to run as root. \033[0m\n"

printf " \n"
printf "\033[0;33m    Prepare directory for public certificates. This is not a secret. \033[0m\n"
buildah run --user root crustde_vscode_img    mkdir -p /home/rustdevuser/.ssh
buildah run --user root crustde_vscode_img    chmod 700 /home/rustdevuser/.ssh
buildah run --user root crustde_vscode_img    chown -R rustdevuser:rustdevuser /home/rustdevuser/.ssh

printf " \n"
printf "\033[0;33m    install ssh server \033[0m\n"
buildah run --user root crustde_vscode_img    apt-get install -y openssh-server

printf " \n"
printf "\033[0;33m    Download vscode-server. Be sure the commit_sha of the server and client is the same: \033[0m\n"
printf "\033[0;33m    In VSCode client open Help-About or in the terminal 'code --version' \033[0m\n" 
printf "\033[0;33m    version vscode 1.103.0 \033[0m\n"
printf "\033[0;33m    e3550cfac4b63ca4eafca7b601f0d2885817fd1f \033[0m\n"
buildah run crustde_vscode_img /bin/sh -c 'mkdir -vp ~/.vscode-server/bin/e3550cfac4b63ca4eafca7b601f0d2885817fd1f'
buildah run crustde_vscode_img /bin/sh -c 'mkdir -vp ~/.vscode-server/extensions'
buildah run crustde_vscode_img /bin/sh -c 'curl -L https://update.code.visualstudio.com/commit:e3550cfac4b63ca4eafca7b601f0d2885817fd1f/server-linux-x64/stable --output /tmp/vscode-server-linux-x64.tar.gz'
buildah run crustde_vscode_img /bin/sh -c 'tar --no-same-owner -xzv --strip-components=1 -C ~/.vscode-server/bin/e3550cfac4b63ca4eafca7b601f0d2885817fd1f -f /tmp/vscode-server-linux-x64.tar.gz'
buildah run crustde_vscode_img /bin/sh -c 'rm /tmp/vscode-server-linux-x64.tar.gz'
buildah run crustde_vscode_img /bin/sh -c '~/.vscode-server/bin/e3550cfac4b63ca4eafca7b601f0d2885817fd1f/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension streetsidesoftware.code-spell-checker'
buildah run crustde_vscode_img /bin/sh -c '~/.vscode-server/bin/e3550cfac4b63ca4eafca7b601f0d2885817fd1f/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension rust-lang.rust-analyzer'
buildah run crustde_vscode_img /bin/sh -c '~/.vscode-server/bin/e3550cfac4b63ca4eafca7b601f0d2885817fd1f/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension davidanson.vscode-markdownlint'
buildah run crustde_vscode_img /bin/sh -c '~/.vscode-server/bin/e3550cfac4b63ca4eafca7b601f0d2885817fd1f/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension dotjoshjohnson.xml'
buildah run crustde_vscode_img /bin/sh -c '~/.vscode-server/bin/e3550cfac4b63ca4eafca7b601f0d2885817fd1f/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension fill-labs.dependi'
buildah run crustde_vscode_img /bin/sh -c '~/.vscode-server/bin/e3550cfac4b63ca4eafca7b601f0d2885817fd1f/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension ms-vscode.live-server'
buildah run crustde_vscode_img /bin/sh -c '~/.vscode-server/bin/e3550cfac4b63ca4eafca7b601f0d2885817fd1f/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension cweijan.vscode-database-client2'

printf " \n"
printf "\033[0;33m    Remove unwanted files \033[0m\n"
buildah run --user root crustde_vscode_img    apt -y autoremove
buildah run --user root crustde_vscode_img    apt -y clean

printf " \n"
printf "\033[0;33m    Finally save/commit the image named crustde_vscode_img \033[0m\n"
buildah commit crustde_vscode_img docker.io/bestiadev/crustde_vscode_img:latest
buildah tag docker.io/bestiadev/crustde_vscode_img:latest docker.io/bestiadev/crustde_vscode_img:vscode-1.103.0
buildah tag docker.io/bestiadev/crustde_vscode_img:latest docker.io/bestiadev/crustde_vscode_img:cargo-1.89.0

printf " \n"
printf "\033[0;33m    Upload the new image to docker hub. \033[0m\n"
printf "\033[0;32m ./ssh_auth_podman_push docker.io/bestiadev/crustde_vscode_img:vscode-1.103.0 \033[0m\n"
printf "\033[0;32m ./ssh_auth_podman_push docker.io/bestiadev/crustde_vscode_img:cargo-1.89.0 \033[0m\n"
printf "\033[0;32m ./ssh_auth_podman_push docker.io/bestiadev/crustde_vscode_img:latest \033[0m\n"

printf " \n"
printf "\033[0;33m    This image is used solely inside the pod 'crustde_pod'. \033[0m\n"
printf "\033[0;33m    Follow the instructions to install the CRUSTDE pod: \033[0m\n"
printf "\033[0;32m https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod \033[0m\n"

printf " \n"
