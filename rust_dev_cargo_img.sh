#!/usr/bin/env bash

echo " "
echo "Bash script to build the docker image for development in Rust."
echo "Name of the image: rust_dev_cargo_img"
echo "repository: https://github.com/bestia-dev/docker_rust_development"

echo " "
echo "I want a sandbox that cannot compromise my local system."
echo "No shared volumes. All the files and folders will be inside the container. "
echo "The original source code files will be cloned from github or copied from the local system."
echo "The final source code files will be pushed to github or copied to the local system."
echo "I want also to limit the network ports and addresses inbound and outbound."

echo " "
echo "To build the image, run in bash with:"
echo "sh rust_dev_cargo_img.sh"

echo " "
echo "Removing container and image if exists"
# Be careful, this container is not meant to have persistent data.
# the '|| :' in combination with 'set -e' means that 
# the error is ignored if the container does not exist.
set -e
podman rm rust_dev_cargo_cnt || :
buildah rm rust_dev_cargo_img || :
buildah rmi -f docker.io/bestiadev/rust_dev_cargo_img || :


echo " "
echo "Create new container named rust_dev_cargo_img"
set -o errexit
buildah from --name rust_dev_cargo_img docker.io/library/debian:bullseye-slim


buildah config \
--author=github.com/bestia-dev \
--label name=rust_dev_cargo_img \
--label version=1.0 \
--label source=github.com/bestia-dev/docker_rust_development \
rust_dev_cargo_img

echo " "
echo "apk update"
buildah run rust_dev_cargo_img    apt -y update
buildah run rust_dev_cargo_img    apt -y upgrade

echo " "
echo "Install curl, git, rsync and build-essential with root user"
buildah run rust_dev_cargo_img    apt -y install curl
buildah run rust_dev_cargo_img    apt -y install git
buildah run rust_dev_cargo_img    apt -y install rsync
buildah run rust_dev_cargo_img    apt -y install build-essential
buildah run rust_dev_cargo_img    apt -y install nano

echo " "
echo "Create non-root user 'rustdevuser' and home folder."
buildah run rust_dev_cargo_img    useradd -ms /bin/bash rustdevuser

echo " "
echo "Use rustdevuser for all subsequent commands."
buildah config --user rustdevuser rust_dev_cargo_img
buildah config --workingdir /home/rustdevuser rust_dev_cargo_img

# If needed, the user can be forced for a buildah command:
# buildah run  --user root rust_dev_cargo_img    apt -y --no-install-recommends install build-essential

echo " "
echo "Configure rustdevuser things"
buildah run rust_dev_cargo_img /bin/sh -c 'mkdir -vp ~/rustprojects'
buildah run rust_dev_cargo_img /bin/sh -c 'mkdir -vp ~/.ssh'
buildah run rust_dev_cargo_img /bin/sh -c 'chmod 700 ~/.ssh'

echo " "
echo "Kill auto-completion horrible sound"
buildah run rust_dev_cargo_img /bin/sh -c 'echo "set bell-style none" >> ~/.inputrc'

echo " "
echo "Install rustup and default x86_64-unknown-linux-gnu, cargo, std, rustfmt, clippy, docs, rustc,... "
buildah run rust_dev_cargo_img /bin/sh -c 'curl https://sh.rustup.rs -sSf | sh -s -- -yq'

echo "Rustup wants to add the ~/.cargo/bin to PATH. But it needs to force bash reboot and that does not work in buildah."
echo "Add the PATH to ~/.cargo/bin manually"
OLDIMAGEPATH=$(buildah run rust_dev_cargo_img printenv PATH)
buildah config --env PATH=/home/rustdevuser/.cargo/bin:$OLDIMAGEPATH rust_dev_cargo_img
buildah run rust_dev_cargo_img /bin/sh -c 'echo $PATH'

# this probably is not necessary, if rust-analyzer can call rust-lang.org
# buildah config --env RUST_SRC_PATH=/home/rustdevuser/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library rust_dev_cargo_img
# buildah run rust_dev_cargo_img /bin/sh -c 'echo $RUST_SRC_PATH'

buildah run rust_dev_cargo_img /bin/sh -c 'rustup component add rust-src'

echo "remove the toolchain docs, because they are 610MB big"
buildah run rust_dev_cargo_img /bin/sh -c 'rm -rf /home/rustdevuser/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/share/doc'

echo " "
echo "Install cargo-auto. It will pull the cargo-index registry. The first pull can take some time."
buildah run rust_dev_cargo_img /bin/sh -c 'cargo install cargo-auto'
buildah run rust_dev_cargo_img /bin/sh -c 'curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh'
buildah run rust_dev_cargo_img /bin/sh -c 'cargo install dev_bestia_cargo_completion'

echo " "
echo "Add line dev_bestia_cargo_completion to .bashrc"
buildah run rust_dev_cargo_img /bin/sh -c 'echo "# dev_bestia_cargo_completion" >> ~/.bashrc'
buildah run rust_dev_cargo_img /bin/sh -c 'echo "complete -C dev_bestia_cargo_completion cargo" >> ~/.bashrc'
# buildah run rust_dev_cargo_img /bin/sh -c 'cat ~/.bashrc'

echo " "
echo "Remove unwanted files"
buildah run --user root rust_dev_cargo_img    apt -y autoremove
buildah run --user root rust_dev_cargo_img    apt -y clean

echo " "
echo "Finally save/commit the image named rust_dev_cargo_img"
buildah commit rust_dev_cargo_img docker.io/bestiadev/rust_dev_cargo_img:latest

# TODO: dynamically ask ' cargo --version' and write the answer in the tag:
buildah tag docker.io/bestiadev/rust_dev_cargo_img:latest docker.io/bestiadev/rust_dev_cargo_img:cargo-1.59.0

echo " "
echo " To create the container 'rust_dev_cargo_cnt' use:"
echo "podman create -ti --name rust_dev_cargo_cnt docker.io/bestiadev/rust_dev_cargo_img:latest"

echo " "
echo " Copy your ssh certificates for github and publish_to_web:"
echo "podman cp ~/.ssh/githubssh1 rust_dev_cargo_cnt:/home/rustdevuser/.ssh/githubssh1"

echo " "
echo " To start the container use and then interact with bash:"
echo "podman start rust_dev_cargo_cnt"
echo "podman exec -it rust_dev_cargo_cnt bash"

echo " "
echo " Inside the container run the ssh-agent to store your ssh passphrase for git and publish_to_web:"
echo "cd /home/rustdevuser"
echo "eval \$(ssh-agent) "
echo "ssh-add /home/rustdevuser/.ssh/githubssh1"
echo "cd rustprojects"

echo " "
echo " Try to build and run a sample Rust project:"
echo "cargo new rust_dev_hello"
echo "cd rust_dev_hello"
echo "cargo run"

echo " "
echo " Detach container (it will remain 'started') with:"
echo "Ctrl+P, Ctrl+Q"

echo " "
echo "To Exit/Stop the container type:"
echo " exit"
