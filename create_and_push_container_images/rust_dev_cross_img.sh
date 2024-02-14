#!/bin/sh

# README:

echo " "
echo "\033[0;33m    Bash script to build the docker image for cross-compile for Rust. \033[0m"
echo "\033[0;33m    Name of the image: rust_dev_cross_img \033[0m"
# repository: https://github.com/bestia-dev/docker_rust_development

echo " "
echo "\033[0;33m    The original rust_dev_cargo_img will compile only for linux. \033[0m"
echo "\033[0;33m    The Cross-compilation container will target: Windows, Musl, WASI and WASM.  \033[0m"

echo " "
echo "\033[0;33m    To build the image, run in bash with: \033[0m"
echo "\033[0;33m sh rust_dev_cross_img.sh \033[0m"

# Start of script actions:

echo " "
echo "\033[0;33m    Removing container and image if exists \033[0m"
# Be careful, this container is not meant to have persistent data.
# the '|| :' in combination with 'set -e' means that 
# the error is ignored if the container does not exist.
set -e
podman rm rust_dev_cross_cnt || :
buildah rm rust_dev_cross_img || :
buildah rmi -f docker.io/bestiadev/rust_dev_cross_img || :


echo " "
echo "\033[0;33m    Create new 'buildah container' named rust_dev_cross_img \033[0m"
set -o errexit
buildah from \
--name rust_dev_cross_img \
docker.io/bestiadev/rust_dev_cargo_img:latest

buildah config \
--author=github.com/bestia-dev \
--label name=rust_dev_cross_img \
--label version=cargo-1.76.0 \
--label source=github.com/bestia-dev/docker_rust_development \
rust_dev_cross_img

echo " "
echo "\033[0;33m    Add mingw-w64 and target for cross-compile to Windows \033[0m"
buildah run --user root rust_dev_cross_img /bin/sh -c 'apt-get install -y mingw-w64'
buildah run rust_dev_cross_img /bin/sh -c 'rustup target add x86_64-pc-windows-gnu'

echo " "
echo "\033[0;33m    Add musl-tools and target for compile to musl (full static executable) \033[0m"
buildah run --user root rust_dev_cross_img /bin/sh -c 'apt-get install -y musl-tools'
buildah run rust_dev_cross_img /bin/sh -c 'rustup target add x86_64-unknown-linux-musl'

echo " "
echo "\033[0;33m    Add target for compile to wasm32-wasi \033[0m"
buildah run rust_dev_cross_img /bin/sh -c 'rustup target add wasm32-wasi'

echo " "
echo "\033[0;33m    Install wasm pack \033[0m"
buildah run rust_dev_cross_img /bin/sh -c 'curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | bash'

echo " "
echo "\033[0;33m    Install wasmtime wasi runtime \033[0m"
buildah run rust_dev_cross_img /bin/sh -c 'curl https://wasmtime.dev/install.sh -sSf | bash'

echo " "
echo "\033[0;33m    Finally save/commit the image named rust_dev_cross_img \033[0m"
buildah commit rust_dev_cross_img docker.io/bestiadev/rust_dev_cross_img:latest
buildah tag docker.io/bestiadev/rust_dev_cross_img:latest docker.io/bestiadev/rust_dev_cross_img:cargo-1.76.0

echo " "
echo "\033[0;33m    Upload the new image to docker hub. \033[0m"
echo "\033[0;33m    First you need to store the credentials with: \033[0m"
echo "\033[0;32m podman login --username bestiadev docker.io \033[0m"
echo "\033[0;33m    then type docker access token. \033[0m"
echo "\033[0;32m podman push docker.io/bestiadev/rust_dev_cross_img:cargo-1.76.0 \033[0m"
echo "\033[0;32m podman push docker.io/bestiadev/rust_dev_cross_img:latest \033[0m"

echo " "
echo "\033[0;33m    To create the container 'rust_dev_cross_cnt' use: \033[0m"
echo "\033[0;32m podman create -ti --name rust_dev_cross_cnt docker.io/bestiadev/rust_dev_cross_img:latest \033[0m"
echo "\033[0;32m podman restart rust_dev_cross_cnt \033[0m"
echo "\033[0;32m podman exec -it rust_dev_cross_cnt bash \033[0m"

echo " "
echo "\033[0;33m    Try to build and run a sample Rust project: \033[0m"
echo "\033[0;32m cd ~/rustprojects \033[0m"
echo "\033[0;32m cargo new rust_dev_hello \033[0m"
echo "\033[0;32m cd rust_dev_hello \033[0m"
echo "\033[0;32m cargo run \033[0m"

echo " "
echo "\033[0;33m    Detach container (it will remain 'started') with: \033[0m"
echo "\033[0;32m Ctrl+P, Ctrl+Q \033[0m"

echo " "
echo "\033[0;33m    To Exit/Stop the container type: \033[0m"
echo "\033[0;32m exit \033[0m"
echo " "

echo " "
echo "\033[0;33m    Continue other images creation with: \033[0m"
echo "\033[0;32m sh rust_dev_vscode_img.sh \033[0m"
echo " "