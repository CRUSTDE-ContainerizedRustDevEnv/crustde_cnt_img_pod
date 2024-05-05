#!/bin/sh

# README:

printf " \n"
printf "\033[0;33m    Bash script to build the docker image for development in Rust. \033[0m\n"
printf "\033[0;33m    Name of the image: crustde_cargo_img \033[0m\n"
# repository: https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod

printf " \n"
printf "\033[0;33m    I want a sandbox that cannot compromise my local system. \033[0m\n"
printf "\033[0;33m    No shared volumes. All the files and folders will be inside the container.  \033[0m\n"
printf "\033[0;33m    Containers are not perfect sandboxes, but are good enough. \033[0m\n"
printf "\033[0;33m    Containers images can be recreated easily, coherently and repeatedly with new versions of tools. \033[0m\n"
printf "\033[0;33m    I want also to limit the network ports and addresses inbound and outbound. \033[0m\n"
printf "\033[0;33m    Open source code MIT: https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod \033[0m\n"

printf " \n"
printf "\033[0;33m    FIRST !!! \033[0m\n"
printf "\033[0;33m    Search and replace in this bash script to the newest version: \033[0m\n"
printf "\033[0;33m    Version of Debian: 12.5 \033[0m\n"
printf "\033[0;33m    Version of rustup: 1.27.0 \033[0m\n"
printf "\033[0;33m    Version of rustc: 1.78.0 \033[0m\n"
printf "\033[0;33m    Version of sccache: 0.8.0 \033[0m\n"

printf " \n"
printf "\033[0;33m    To build the image, run in bash with: \033[0m\n"
printf "\033[0;33m sh crustde_cargo_img.sh \033[0m\n"

# Start of script actions:

printf " \n"
printf "\033[0;33m    Removing container and image if exist. This will remove all the data inside the old container. \033[0m\n"
printf "\033[0;33m    Ignore errors if container and image does not exist \033[0m\n"

# Be careful, this container is not meant to have persistent data.
# the '|| :' in combination with 'set -e' means that 
# the error is ignored if the container does not exist.
set -e
podman rm crustde_cargo_cnt || :
buildah rm crustde_cargo_img || :
buildah rmi -f docker.io/bestiadev/crustde_cargo_img || :


printf " \n"
printf "\033[0;33m    Create new 'buildah container' named crustde_cargo_img \033[0m\n"
set -o errexit
buildah from \
--name crustde_cargo_img \
docker.io/library/debian:bookworm-slim


buildah config \
--author=github.com/bestia-dev \
--label name=crustde_cargo_img \
--label version=cargo-1.78.0 \
--label source=github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod \
crustde_cargo_img

printf " \n"
printf "\033[0;33m    Debian apt update and upgrade \033[0m\n"
buildah run crustde_cargo_img    apt -y update
buildah run crustde_cargo_img    apt -y full-upgrade

printf " \n"
printf "\033[0;33m    Install curl, the most used CLI for getting stuff from internet \033[0m\n"
buildah run crustde_cargo_img    apt-get install -y curl
printf "\033[0;33m    Install git, the legendary source control system \033[0m\n"
buildah run crustde_cargo_img    apt-get install -y git
printf "\033[0;33m    Install rsync, it is great for copying files and folders \033[0m\n"
buildah run crustde_cargo_img    apt-get install -y rsync
printf "\033[0;33m    Install build-essential. Rust needs some the C stuff.  \033[0m\n"
buildah run crustde_cargo_img    apt-get install -y build-essential
printf "\033[0;33m    Install nano, the default easy to use text editor in Debian \033[0m\n"
buildah run crustde_cargo_img    apt-get install -y nano
printf "\033[0;33m    Install ps. It displays information about a selection of the active processes \033[0m\n"
printf "\033[0;33m    concretely it is used to run the ssh-agent  \033[0m\n"
buildah run crustde_cargo_img    apt-get install -y procps
printf "\033[0;33m    Install pkg-config and libssl-dev are needed by the crate reqwest to work with TLS/SSL. \033[0m\n"
buildah run crustde_cargo_img    apt-get install -y pkg-config
buildah run crustde_cargo_img    apt-get install -y libssl-dev
printf "\033[0;33m    Install postgres client for postgres 13. \033[0m\n"
buildah run crustde_cargo_img    apt-get install -y postgresql-client
printf "\033[0;33m    Install lsb_release for Debian version \033[0m\n"
buildah run crustde_cargo_img    apt-get install -y lsb-release
printf "\033[0;33m    Install tidy HTML - corrects and cleans up HTML and XML \033[0m\n"
buildah run crustde_cargo_img    apt-get install -y tidy

printf " \n"

printf " \n"

# If needed, the user can be forced for a buildah command:
# buildah run  --user root crustde_cargo_img    apt-get install -y --no-install-recommends build-essential

printf " \n"
buildah run crustde_cargo_img /bin/sh -c 'mkdir -vp ~/rustprojects'

# copy file pull_all.sh
buildah copy crustde_cargo_img './pull_all.sh' '~/rustprojects/pull_all.sh'

buildah run crustde_cargo_img /bin/sh -c 'mkdir -vp ~/.ssh'
buildah run crustde_cargo_img /bin/sh -c 'chmod 700 ~/.ssh'

printf " \n"
printf "\033[0;33m    Kill auto-completion horrible sound \033[0m\n"
buildah run crustde_cargo_img /bin/sh -c 'printf "set bell-style none\n" >> ~/.inputrc'

printf " \n"
printf "\033[0;33m    Install rustup 1.27.0 and default x86_64-unknown-linux-gnu, cargo, std, rustfmt, clippy, docs, rustc,...  \033[0m\n"
buildah run crustde_cargo_img /bin/sh -c 'curl https://sh.rustup.rs -sSf | sh -s -- -yq'

printf "\033[0;33m    Rustup wants to add the ~/.cargo/bin to PATH. But it needs to force bash reboot and that does not work in buildah. \033[0m\n"
printf "\033[0;33m    Add the PATH to ~/.cargo/bin manually \033[0m\n"
OLDIMAGEPATH=$(buildah run crustde_cargo_img printenv PATH)
buildah run crustde_cargo_img /bin/sh -c 'printf "$PATH\n"'

printf " \n"
printf "\033[0;33m    Debian version \033[0m\n"
buildah run crustde_cargo_img /bin/sh -c 'lsb_release -d'
# Debian GNU/Linux 12 (bookworm)
buildah run crustde_cargo_img /bin/sh -c 'cat /etc/debian_version'
# 12.5

printf "\033[0;33m    rustup version \033[0m\n"
buildah run crustde_cargo_img /bin/sh -c 'rustup --version'
# rustup 1.27.0 

printf "\033[0;33m    rustc version \033[0m\n"
# rustc 1.78.0 

printf "\033[0;33m    psql version \033[0m\n"
buildah run crustde_cargo_img /bin/sh -c 'psql --version'
# The default PostgreSQL 15 is available to install on Debian 12 bookworm Linux.
# psql (PostgreSQL) 15.5 (Debian 15.5-0+deb12u1)

# this probably is not necessary, if rust-analyzer can call rust-lang.org
# buildah run crustde_cargo_img /bin/sh -c 'printf "$RUST_SRC_PATH\n"'

printf " \n"
printf "\033[0;33m    Add rust-src for debugging \033[0m\n"
buildah run crustde_cargo_img /bin/sh -c 'rustup component add rust-src'

printf " \n"
printf "\033[0;33m    Remove the toolchain docs because they are 610MB big \033[0m\n"

printf " \n"
printf "\033[0;33m    Install 'mold linker' 2.31.0. It is 3x faster. \033[0m\n"
buildah run crustde_cargo_img /bin/sh -c 'curl -L https://github.com/rui314/mold/releases/download/v2.31.0/mold-2.31.0-x86_64-linux.tar.gz --output /tmp/mold.tar.gz'
buildah run --user root  crustde_cargo_img /bin/sh -c 'tar --no-same-owner -xzv --strip-components=2 -C /usr/bin -f /tmp/mold.tar.gz --wildcards */bin/mold'
buildah run crustde_cargo_img /bin/sh -c 'rm /tmp/mold.tar.gz'

buildah run --user root  crustde_cargo_img    chown root:root /usr/bin/mold
buildah run --user root  crustde_cargo_img    chmod 755 /usr/bin/mold

printf " \n"
printf "\033[0;33m    With GCC advise to use a workaround to -fuse-ld \033[0m\n"

printf " \n"
printf "\033[0;33m    Install cargo-auto. \033[0m\n"
buildah run crustde_cargo_img /bin/sh -c 'cargo install cargo-auto'
buildah run crustde_cargo_img /bin/sh -c 'cargo install dev_bestia_cargo_completion'

printf " \n"
printf "\033[0;33m    Install basic-http-server to work with WASM. \033[0m\n"
buildah run crustde_cargo_img /bin/sh -c 'cargo install basic-http-server'

printf " \n"
printf "\033[0;33m    Install sccache 0.8.0 to cache compiled artifacts. \033[0m\n"
buildah run crustde_cargo_img /bin/sh -c 'curl -L https://github.com/mozilla/sccache/releases/download/v0.8.0/sccache-v0.8.0-x86_64-unknown-linux-musl.tar.gz --output /tmp/sccache.tar.gz'
buildah run crustde_cargo_img /bin/sh -c 'tar --no-same-owner -xzv --strip-components=1 -C ~/.cargo/bin -f /tmp/sccache.tar.gz --wildcards */sccache'
buildah run crustde_cargo_img /bin/sh -c 'rm /tmp/sccache.tar.gz'

printf " \n"
printf "\033[0;33m    Add alias l for ls -la in .bashrc \033[0m\n"
buildah run crustde_cargo_img /bin/sh -c 'printf "alias l=\"ls -al\"\n" >> ~/.bashrc'
buildah run crustde_cargo_img /bin/sh -c 'printf "alias ll=\"ls -l\"\n" >> ~/.bashrc'

printf " \n"
printf "\033[0;33m    Add ssh-agent to .bashrc \033[0m\n"

printf " \n"
printf "\033[0;33m    Copy file cargo_config.toml because of 'mold linker' and sccache \033[0m\n"

printf " \n"
printf "\033[0;33m    Remove unwanted files \033[0m\n"
buildah run --user root crustde_cargo_img    apt -y autoremove
buildah run --user root crustde_cargo_img    apt -y clean

printf " \n"
printf "\033[0;33m    Finally save/commit the image named crustde_cargo_img \033[0m\n"
buildah commit crustde_cargo_img docker.io/bestiadev/crustde_cargo_img:latest
buildah tag docker.io/bestiadev/crustde_cargo_img:latest docker.io/bestiadev/crustde_cargo_img:cargo-1.78.0

printf " \n"
printf "\033[0;33m    Upload the new image to docker hub. \033[0m\n"
printf "\033[0;32m ./ssh_auth_podman_push docker.io/bestiadev/crustde_cargo_img:cargo-1.78.0 \033[0m\n"
printf "\033[0;32m ./ssh_auth_podman_push docker.io/bestiadev/crustde_cargo_img:latest \033[0m\n"

printf " \n"
printf "\033[0;33m    To create the container 'crustde_cargo_cnt' use: \033[0m\n"
printf "\033[0;32m podman create -ti --name crustde_cargo_cnt docker.io/bestiadev/crustde_cargo_img:latest \033[0m\n"
printf "\033[0;32m podman restart crustde_cargo_cnt \033[0m\n"
printf "\033[0;32m podman exec -it crustde_cargo_cnt bash \033[0m\n"

printf " \n"
printf "\033[0;33m    Try to build and run a sample Rust project: \033[0m\n"
printf "\033[0;32m cd ~/rustprojects \033[0m\n"
printf "\033[0;32m cargo new crustde_hello \033[0m\n"
printf "\033[0;32m cd crustde_hello \033[0m\n"
printf "\033[0;32m cargo run \033[0m\n"

printf " \n"
printf "\033[0;33m    Detach container with - it will remain 'started': \033[0m\n"
printf "\033[0;32m Ctrl+P, Ctrl+Q \033[0m\n"

printf " \n"
printf "\033[0;33m    To Exit/Stop the container type: \033[0m\n"
printf "\033[0;32m exit \033[0m\n"
printf " \n"

printf " \n"
printf "\033[0;33m    Continue other images creation with: \033[0m\n"
printf "\033[0;32m sh crustde_cross_img.sh \033[0m\n"
printf " \n"