#!/bin/sh

# README:

printf " \n"
printf "\033[0;33m    Bash script to build the docker image for cross-compile for Rust. \033[0m\n"
printf "\033[0;33m    Name of the image: crustde_cross_img \033[0m\n"
# repository: https://github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod

printf " \n"
printf "\033[0;33m    The original crustde_cargo_img will compile only for linux. \033[0m\n"
printf "\033[0;33m    The Cross-compilation container will target: Windows, Musl, WASI and WASM.  \033[0m\n"

printf " \n"
printf "\033[0;33m    To build the image, run in bash with: \033[0m\n"
printf "\033[0;33m sh crustde_cross_img.sh \033[0m\n"

# Start of script actions:

printf " \n"
printf "\033[0;33m    Removing container and image if exists \033[0m\n"
# Be careful, this container is not meant to have persistent data.
# the '|| :' in combination with 'set -e' means that 
# the error is ignored if the container does not exist.
set -e
podman rm crustde_cross_cnt || :
buildah rm crustde_cross_img || :
buildah rmi -f docker.io/bestiadev/crustde_cross_img || :


printf " \n"
printf "\033[0;33m    Create new 'buildah container' named crustde_cross_img \033[0m\n"
set -o errexit
buildah from \
--name crustde_cross_img \
docker.io/bestiadev/crustde_cargo_img:latest

buildah config \
--author=github.com/bestia-dev \
--label name=crustde_cross_img \
--label version=cargo-1.79.0 \
--label source=github.com/CRUSTDE-ContainerizedRustDevEnv/crustde_cnt_img_pod \
crustde_cross_img

printf " \n"
printf "\033[0;33m    Add mingw-w64 and target for cross-compile to Windows \033[0m\n"
buildah run --user root crustde_cross_img /bin/sh -c 'apt-get install -y mingw-w64'
buildah run crustde_cross_img /bin/sh -c 'rustup target add x86_64-pc-windows-gnu'

printf " \n"
printf "\033[0;33m    Add musl-tools and target for compile to musl (full static executable) \033[0m\n"
buildah run --user root crustde_cross_img /bin/sh -c 'apt-get install -y musl-tools'
buildah run crustde_cross_img /bin/sh -c 'rustup target add x86_64-unknown-linux-musl'

printf " \n"
printf "\033[0;33m    Add target for compile to wasm32-wasi \033[0m\n"
buildah run crustde_cross_img /bin/sh -c 'rustup target add wasm32-wasi'

printf " \n"
printf "\033[0;33m    Install wasm pack \033[0m\n"
buildah run crustde_cross_img /bin/sh -c 'curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | bash'

printf " \n"
printf "\033[0;33m    Install wasmtime wasi runtime \033[0m\n"
buildah run crustde_cross_img /bin/sh -c 'curl https://wasmtime.dev/install.sh -sSf | bash'

printf " \n"
printf "\033[0;33m    Finally save/commit the image named crustde_cross_img \033[0m\n"
buildah commit crustde_cross_img docker.io/bestiadev/crustde_cross_img:latest
buildah tag docker.io/bestiadev/crustde_cross_img:latest docker.io/bestiadev/crustde_cross_img:cargo-1.79.0

printf " \n"
printf "\033[0;33m    Upload the new image to docker hub. \033[0m\n"
printf "\033[0;32m ./ssh_auth_podman_push docker.io/bestiadev/crustde_cross_img:cargo-1.79.0 \033[0m\n"
printf "\033[0;32m ./ssh_auth_podman_push docker.io/bestiadev/crustde_cross_img:latest \033[0m\n"

printf " \n"
printf "\033[0;33m    To create the container 'crustde_cross_cnt' use: \033[0m\n"
printf "\033[0;32m podman create -ti --name crustde_cross_cnt docker.io/bestiadev/crustde_cross_img:latest \033[0m\n"
printf "\033[0;32m podman restart crustde_cross_cnt \033[0m\n"
printf "\033[0;32m podman exec -it crustde_cross_cnt bash \033[0m\n"

printf " \n"
printf "\033[0;33m    Try to build and run a sample Rust project: \033[0m\n"
printf "\033[0;32m cd ~/rustprojects \033[0m\n"
printf "\033[0;32m cargo new crustde_hello \033[0m\n"
printf "\033[0;32m cd crustde_hello \033[0m\n"
printf "\033[0;32m cargo run \033[0m\n"

printf " \n"
printf "\033[0;33m    Detach container (it will remain 'started') with: \033[0m\n"
printf "\033[0;32m Ctrl+P, Ctrl+Q \033[0m\n"

printf " \n"
printf "\033[0;33m    To Exit/Stop the container type: \033[0m\n"
printf "\033[0;32m exit \033[0m\n"
printf " \n"

printf " \n"
printf "\033[0;33m    Continue other images creation with: \033[0m\n"
printf "\033[0;32m sh crustde_vscode_img.sh \033[0m\n"
printf " \n"