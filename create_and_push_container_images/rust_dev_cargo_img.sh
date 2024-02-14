#!/bin/sh

# README:

echo " "
echo "\033[0;33m    Bash script to build the docker image for development in Rust. \033[0m"
echo "\033[0;33m    Name of the image: rust_dev_cargo_img \033[0m"
# repository: https://github.com/bestia-dev/docker_rust_development

echo " "
echo "\033[0;33m    I want a sandbox that cannot compromise my local system. \033[0m"
echo "\033[0;33m    No shared volumes. All the files and folders will be inside the container.  \033[0m"
echo "\033[0;33m    Containers are not perfect sandboxes, but are good enough. \033[0m"
echo "\033[0;33m    Containers images can be recreated easily, coherently and repeatedly with new versions of tools. \033[0m"
echo "\033[0;33m    I want also to limit the network ports and addresses inbound and outbound. \033[0m"
echo "\033[0;33m    Open source code MIT: https://github.com/bestia-dev/docker_rust_development \033[0m"

echo " "
echo "\033[0;33m    FIRST !!! \033[0m"
echo "\033[0;33m    Search and replace in this bash script to the newest version: \033[0m"
echo "\033[0;33m    Version of Debian: 12.5 \033[0m"
echo "\033[0;33m    Version of rustup: 1.26.0 \033[0m"
echo "\033[0;33m    Version of rustc: 1.76.0 \033[0m"
echo "\033[0;33m    Version of sccache: 0.7.7 \033[0m"

echo " "
echo "\033[0;33m    To build the image, run in bash with: \033[0m"
echo "\033[0;33m sh rust_dev_cargo_img.sh \033[0m"

# Start of script actions:

echo " "
echo "\033[0;33m    Removing container and image if exist. This will remove all the data inside the old container. \033[0m"
echo "\033[0;33m    Ignore errors if container and image does not exist \033[0m"

# Be careful, this container is not meant to have persistent data.
# the '|| :' in combination with 'set -e' means that 
# the error is ignored if the container does not exist.
set -e
podman rm rust_dev_cargo_cnt || :
buildah rm rust_dev_cargo_img || :
buildah rmi -f docker.io/bestiadev/rust_dev_cargo_img || :


echo " "
echo "\033[0;33m    Create new 'buildah container' named rust_dev_cargo_img \033[0m"
set -o errexit
buildah from \
--name rust_dev_cargo_img \
docker.io/library/debian:bookworm-slim


buildah config \
--author=github.com/bestia-dev \
--label name=rust_dev_cargo_img \
--label version=cargo-1.76.0 \
--label source=github.com/bestia-dev/docker_rust_development \
rust_dev_cargo_img

echo " "
echo "\033[0;33m    Debian apt update and upgrade \033[0m"
buildah run rust_dev_cargo_img    apt -y update
buildah run rust_dev_cargo_img    apt -y full-upgrade

echo " "
echo "\033[0;33m    Install curl, the most used CLI for getting stuff from internet \033[0m"
buildah run rust_dev_cargo_img    apt-get install -y curl
echo "\033[0;33m    Install git, the legendary source control system \033[0m"
buildah run rust_dev_cargo_img    apt-get install -y git
echo "\033[0;33m    Install rsync, it is great for copying files and folders \033[0m"
buildah run rust_dev_cargo_img    apt-get install -y rsync
echo "\033[0;33m    Install build-essential. Rust needs some the C stuff.  \033[0m"
buildah run rust_dev_cargo_img    apt-get install -y build-essential
echo "\033[0;33m    Install nano, the default easy to use text editor in Debian \033[0m"
buildah run rust_dev_cargo_img    apt-get install -y nano
echo "\033[0;33m    Install ps. It displays information about a selection of the active processes \033[0m"
echo "\033[0;33m    concretely it is used to run the ssh-agent  \033[0m"
buildah run rust_dev_cargo_img    apt-get install -y procps
echo "\033[0;33m    Install pkg-config and libssl-dev are needed by the crate reqwest to work with TLS/SSL. \033[0m"
buildah run rust_dev_cargo_img    apt-get install -y pkg-config
buildah run rust_dev_cargo_img    apt-get install -y libssl-dev
echo "\033[0;33m    Install postgres client for postgres 13. \033[0m"
buildah run rust_dev_cargo_img    apt-get install -y postgresql-client
echo "\033[0;33m    Install lsb_release for Debian version \033[0m"
buildah run rust_dev_cargo_img    apt-get install -y lsb-release
echo "\033[0;33m    Install tidy HTML - corrects and cleans up HTML and XML \033[0m"
buildah run rust_dev_cargo_img    apt-get install -y tidy

echo " "
echo "\033[0;33m    Create non-root user 'rustdevuser' and home folder. \033[0m"
buildah run rust_dev_cargo_img    useradd -ms /bin/bash rustdevuser

echo " "
echo "\033[0;33m    Use rustdevuser for all subsequent commands. \033[0m"
buildah config --user rustdevuser rust_dev_cargo_img
buildah config --workingdir /home/rustdevuser rust_dev_cargo_img

# If needed, the user can be forced for a buildah command:
# buildah run  --user root rust_dev_cargo_img    apt-get install -y --no-install-recommends build-essential

echo " "
echo "\033[0;33m    Configure rustdevuser things \033[0m"
buildah run rust_dev_cargo_img /bin/sh -c 'mkdir -vp ~/rustprojects'
buildah run rust_dev_cargo_img /bin/sh -c 'mkdir -vp ~/.ssh'
buildah run rust_dev_cargo_img /bin/sh -c 'chmod 700 ~/.ssh'

echo " "
echo "\033[0;33m    Kill auto-completion horrible sound \033[0m"
buildah run rust_dev_cargo_img /bin/sh -c 'echo "set bell-style none" >> ~/.inputrc'

echo " "
echo "\033[0;33m    Install rustup 1.26.0 and default x86_64-unknown-linux-gnu, cargo, std, rustfmt, clippy, docs, rustc,...  \033[0m"
buildah run rust_dev_cargo_img /bin/sh -c 'curl https://sh.rustup.rs -sSf | sh -s -- -yq'

echo "\033[0;33m    Rustup wants to add the ~/.cargo/bin to PATH. But it needs to force bash reboot and that does not work in buildah. \033[0m"
echo "\033[0;33m    Add the PATH to ~/.cargo/bin manually \033[0m"
OLDIMAGEPATH=$(buildah run rust_dev_cargo_img printenv PATH)
buildah config --env PATH=/home/rustdevuser/.cargo/bin:$OLDIMAGEPATH rust_dev_cargo_img
buildah run rust_dev_cargo_img /bin/sh -c 'echo $PATH'

echo " "
echo "\033[0;33m    Debian version \033[0m"
buildah run rust_dev_cargo_img /bin/sh -c 'lsb_release -d'
# Debian GNU/Linux 12 (bookworm)
buildah run rust_dev_cargo_img /bin/sh -c 'cat /etc/debian_version'
# 12.5

echo "\033[0;33m    rustup version \033[0m"
buildah run rust_dev_cargo_img /bin/sh -c 'rustup --version'
# rustup 1.26.0 

echo "\033[0;33m    rustc version \033[0m"
buildah run rust_dev_cargo_img /bin/sh -c '/home/rustdevuser/.cargo/bin/rustc --version'
# rustc 1.76.0 

echo "\033[0;33m    psql version \033[0m"
buildah run rust_dev_cargo_img /bin/sh -c 'psql --version'
# The default PostgreSQL 15 is available to install on Debian 12 bookworm Linux.
# psql (PostgreSQL) 15.5 (Debian 15.5-0+deb12u1)

# this probably is not necessary, if rust-analyzer can call rust-lang.org
# buildah config --env RUST_SRC_PATH=/home/rustdevuser/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library rust_dev_cargo_img
# buildah run rust_dev_cargo_img /bin/sh -c 'echo $RUST_SRC_PATH'

echo " "
echo "\033[0;33m    Add rust-src for debugging \033[0m"
buildah run rust_dev_cargo_img /bin/sh -c 'rustup component add rust-src'

echo " "
echo "\033[0;33m    Remove the toolchain docs because they are 610MB big \033[0m"
buildah run rust_dev_cargo_img /bin/sh -c 'rm -rf /home/rustdevuser/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/share/doc'

echo " "
echo "\033[0;33m    Install 'mold linker' 2.4.0. It is 3x faster. \033[0m"
buildah run rust_dev_cargo_img /bin/sh -c 'curl -L https://github.com/rui314/mold/releases/download/v2.4.0/mold-2.4.0-x86_64-linux.tar.gz --output /tmp/mold.tar.gz'
buildah run --user root  rust_dev_cargo_img /bin/sh -c 'tar --no-same-owner -xzv --strip-components=2 -C /usr/bin -f /tmp/mold.tar.gz --wildcards */bin/mold'
buildah run rust_dev_cargo_img /bin/sh -c 'rm /tmp/mold.tar.gz'

buildah run --user root  rust_dev_cargo_img    chown root:root /usr/bin/mold
buildah run --user root  rust_dev_cargo_img    chmod 755 /usr/bin/mold

echo " "
echo "\033[0;33m    With GCC advise to use a workaround to -fuse-ld \033[0m"
buildah run rust_dev_cargo_img    mkdir /home/rustdevuser/.cargo/bin/mold
buildah run rust_dev_cargo_img    ln -s /usr/bin/mold /home/rustdevuser/.cargo/bin/mold/ld

echo " "
echo "\033[0;33m    Install cargo-auto. \033[0m"
buildah run rust_dev_cargo_img /bin/sh -c 'cargo install cargo-auto'
buildah run rust_dev_cargo_img /bin/sh -c 'cargo install dev_bestia_cargo_completion'

echo " "
echo "\033[0;33m    Install basic-http-server to work with WASM. \033[0m"
buildah run rust_dev_cargo_img /bin/sh -c 'cargo install basic-http-server'

echo " "
echo "\033[0;33m    Install sccache 0.7.7 to cache compiled artifacts. \033[0m"
buildah run rust_dev_cargo_img /bin/sh -c 'curl -L https://github.com/mozilla/sccache/releases/download/v0.7.7/sccache-v0.7.7-x86_64-unknown-linux-musl.tar.gz --output /tmp/sccache.tar.gz'
buildah run rust_dev_cargo_img /bin/sh -c 'tar --no-same-owner -xzv --strip-components=1 -C ~/.cargo/bin -f /tmp/sccache.tar.gz --wildcards */sccache'
buildah run rust_dev_cargo_img /bin/sh -c 'rm /tmp/sccache.tar.gz'

echo " "
echo "\033[0;33m    Add alias l for ls -la in .bashrc \033[0m"
buildah run rust_dev_cargo_img /bin/sh -c 'echo "alias l=\"ls -al\"" >> ~/.bashrc'
buildah run rust_dev_cargo_img /bin/sh -c 'echo "alias ll=\"ls -l\"" >> ~/.bashrc'

echo " "
echo "\033[0;33m    Add ssh-agent to .bashrc \033[0m"
buildah run rust_dev_cargo_img /bin/sh -c 'mkdir /home/rustdevuser/.ssh/rust_dev_pod_keys'
buildah copy rust_dev_cargo_img 'bashrc.conf' '/home/rustdevuser/.ssh/rust_dev_pod_keys/bashrc.conf'
buildah run rust_dev_cargo_img /bin/sh -c 'cat /home/rustdevuser/.ssh/rust_dev_pod_keys/bashrc.conf >> ~/.bashrc'

echo " "
echo "\033[0;33m    Copy file cargo_config.toml because of 'mold linker' and sccache \033[0m"
buildah copy rust_dev_cargo_img 'cargo_config.toml' '/home/rustdevuser/.cargo/config.toml'
buildah run --user root rust_dev_cargo_img    chown rustdevuser:rustdevuser /home/rustdevuser/.cargo/config.toml

echo " "
echo "\033[0;33m    Remove unwanted files \033[0m"
buildah run --user root rust_dev_cargo_img    apt -y autoremove
buildah run --user root rust_dev_cargo_img    apt -y clean

echo " "
echo "\033[0;33m    Finally save/commit the image named rust_dev_cargo_img \033[0m"
buildah commit rust_dev_cargo_img docker.io/bestiadev/rust_dev_cargo_img:latest
buildah tag docker.io/bestiadev/rust_dev_cargo_img:latest docker.io/bestiadev/rust_dev_cargo_img:cargo-1.76.0

echo " "
echo "\033[0;33m    Upload the new image to docker hub. \033[0m"
echo "\033[0;33m    First you need to store the credentials with: \033[0m"
echo "\033[0;32m podman login --username bestiadev docker.io \033[0m"
echo "\033[0;33m    then type docker access token. \033[0m"
echo "\033[0;32m podman push docker.io/bestiadev/rust_dev_cargo_img:cargo-1.76.0 \033[0m"
echo "\033[0;32m podman push docker.io/bestiadev/rust_dev_cargo_img:latest \033[0m"

echo " "
echo "\033[0;33m    To create the container 'rust_dev_cargo_cnt' use: \033[0m"
echo "\033[0;32m podman create -ti --name rust_dev_cargo_cnt docker.io/bestiadev/rust_dev_cargo_img:latest \033[0m"
echo "\033[0;32m podman restart rust_dev_cargo_cnt \033[0m"
echo "\033[0;32m podman exec -it rust_dev_cargo_cnt bash \033[0m"

echo " "
echo "\033[0;33m    Try to build and run a sample Rust project: \033[0m"
echo "\033[0;32m cd ~/rustprojects \033[0m"
echo "\033[0;32m cargo new rust_dev_hello \033[0m"
echo "\033[0;32m cd rust_dev_hello \033[0m"
echo "\033[0;32m cargo run \033[0m"

echo " "
echo "\033[0;33m    Detach container with - it will remain 'started': \033[0m"
echo "\033[0;32m Ctrl+P, Ctrl+Q \033[0m"

echo " "
echo "\033[0;33m    To Exit/Stop the container type: \033[0m"
echo "\033[0;32m exit \033[0m"
echo " "

echo " "
echo "\033[0;33m    Continue other images creation with: \033[0m"
echo "\033[0;32m sh rust_dev_cross_img.sh \033[0m"
echo " "