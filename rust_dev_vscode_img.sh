#!/usr/bin/env bash

echo " "
echo "Bash script to build the docker image for development in Rust with VSCode."
echo "Name of the image: rust_dev_vscode_img"
echo "https://github.com/bestia-dev/docker_rust_development"

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
buildah from --name rust_dev_vscode_img docker.io/bestiadev/rust_dev_vscode_img:cargo-1.59.0

buildah config \
--author=github.com/bestia-dev \
--label name=rust_dev_vscode_img \
--label version=1.0 \
--label source=github.com/bestia-dev/docker_rust_development \
rust_dev_vscode_img

echo " "
echo "The subsequent commands are from user rustdevuser."
echo "If I need, I can add '--user root' to run as root."

echo " "
echo "apk update"
buildah run --user root rust_dev_vscode_img    apt -y update
buildah run --user root rust_dev_vscode_img    apt -y upgrade
buildah run --user root rust_dev_vscode_img    apt -y install openssh-server
# prepare directory for public certificates. This is not a secret.
buildah run --user root rust_dev_vscode_img    mkdir -p /home/user_name/.ssh
buildah run --user root rust_dev_vscode_img    chmod 700 /home/rustdevuser/.ssh && chmod 600 /home/rustdevuser/.ssh/
chown -R rustdevuser:rustdevuser /home/rustdevuser/.ssh


echo " "
echo "Download vscode-server. Be sure the commit_sha of the server and client is the same:"
echo "In VSCode client open Help-About. version 1.66.0"
echo "e18005f0f1b33c29e81d732535d8c0e47cafb0b5"
buildah run rust_dev_vscode_img /bin/sh -c 'mkdir -vp ~/.vscode-server/bin/e18005f0f1b33c29e81d732535d8c0e47cafb0b5'
buildah run rust_dev_vscode_img /bin/sh -c 'mkdir -vp ~/.vscode-server/extensions'
buildah run rust_dev_vscode_img /bin/sh -c 'curl -L https://update.code.visualstudio.com/commit:e18005f0f1b33c29e81d732535d8c0e47cafb0b5/server-linux-x64/stable --output /tmp/vscode-server-linux-x64.tar.gz'
buildah run rust_dev_vscode_img /bin/sh -c 'tar --no-same-owner -xzv --strip-components=1 -C ~/.vscode-server/bin/e18005f0f1b33c29e81d732535d8c0e47cafb0b5 -f /tmp/vscode-server-linux-x64.tar.gz'
buildah run rust_dev_vscode_img /bin/sh -c 'rm /tmp/vscode-server-linux-x64.tar.gz'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/e18005f0f1b33c29e81d732535d8c0e47cafb0b5/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension streetsidesoftware.code-spell-checker'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/e18005f0f1b33c29e81d732535d8c0e47cafb0b5/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension matklad.rust-analyzer'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/e18005f0f1b33c29e81d732535d8c0e47cafb0b5/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension davidanson.vscode-markdownlint'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/e18005f0f1b33c29e81d732535d8c0e47cafb0b5/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension 2gua.rainbow-brackets'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/e18005f0f1b33c29e81d732535d8c0e47cafb0b5/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension dotjoshjohnson.xml'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/e18005f0f1b33c29e81d732535d8c0e47cafb0b5/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension serayuzgur.crates'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/e18005f0f1b33c29e81d732535d8c0e47cafb0b5/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension bierner.markdown-mermaid'
buildah run rust_dev_vscode_img /bin/sh -c '~/.vscode-server/bin/e18005f0f1b33c29e81d732535d8c0e47cafb0b5/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension ms-vscode.live-server'

echo " "
echo "Remove unwanted files"
buildah run --user root rust_dev_vscode_img    apt -y autoremove
buildah run --user root rust_dev_vscode_img    apt -y clean

echo " "
echo "Finally save/commit the image named rust_dev_vscode_img"
buildah commit rust_dev_vscode_img docker.io/bestiadev/rust_dev_vscode_img:latest

buildah tag docker.io/bestiadev/rust_dev_vscode_img:latest docker.io/bestiadev/rust_dev_vscode_img:vscode-1.66.0
buildah tag docker.io/bestiadev/rust_dev_vscode_img:latest docker.io/bestiadev/rust_dev_vscode_img:cargo-1.59.0

echo " "
echo " To create the container 'rust_dev_vscode_cnt' use:"
echo "podman create -ti --name rust_dev_vscode_cnt docker.io/bestiadev/rust_dev_vscode_img:latest"

echo " "
echo " Copy your ssh certificates for github and publish_to_web:"
echo "podman cp ~/.ssh/certssh1 rust_dev_vscode_cnt:/home/rustdevuser/.ssh/certssh1"
echo "podman cp ~/.ssh/certssh2 rust_dev_vscode_cnt:/home/rustdevuser/.ssh/certssh2"

echo " "
echo " Start the container:"
echo "podman start rust_dev_vscode_cnt"

echo " "
echo " Firstly: attach VSCode to the running container."
echo "Open VSCode, press F1, type 'attach' and choose 'Remote-Containers:Attach to Running container...' and type rust_dev_vscode_cnt" 
echo " This will open a new VSCode windows attached to the container."
echo " If needed Open VSCode terminal with Ctrl+J"
echo " Inside VSCode terminal, go to the project folder. Here we will create a sample project:"
echo "cd ~/rustprojects"
echo "cargo new rust_dev_hello"
echo "cd ~/rustprojects/rust_dev_hello"

echo " "
echo " Secondly: open a new VSCode window exactly for this project/folder."
echo "code ."
echo " A new VSCode windows will open for the 'rust_dev_hello' project. You can close now all other VSCode windows."

echo " "
echo " Build and run the project in the VSCode terminal:"
echo "cargo run"

echo " "
echo " If you need ssh for git or publish_to_web, inside the VSCode terminal run the ssh-agent:"
echo "eval $(ssh-agent) "
echo "ssh-add /home/rustdevuser/.ssh/certssh1"
echo "ssh-add /home/rustdevuser/.ssh/certssh2"
