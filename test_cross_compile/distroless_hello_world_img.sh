#!/bin/sh

# README:

echo " "
echo "\033[0;33m    Bash script to build distroless static image to test execute hello_world with and without musl. \033[0m"
echo "\033[0;33m    Name of the image: distroless_hello_world_img \033[0m"
# repository: https://github.com/bestia-dev/docker_rust_development

echo " "
echo "\033[0;33m    Rust can cross compile with statically link to the musl library. \033[0m"
echo "\033[0;33m    That can be run from a minimal distroless Linux OCI container. Only 5MB.  \033[0m"
echo "\033[0;33m    By default Rust programs are dynamically linked to glibc and that cannot work on distroless static Debian,  \033[0m"
echo "\033[0;33m    because it does not come installed with this big library.  \033[0m"

echo " "
echo "\033[0;33m    To build the image, run in bash with: \033[0m"
echo "\033[0;33m sh distroless_hello_world_img.sh \033[0m"

# Start of script actions:

echo " "
echo "\033[0;33m    Removing container and image if exists \033[0m"
# Be careful, this container is not meant to have persistent data.
# the '|| :' in combination with 'set -e' means that 
# the error is ignored if the container does not exist.
set -e
buildah rm distroless_hello_world_img || :
buildah rmi -f docker.io/bestiadev/distroless_hello_world_img || :

echo " "
echo "\033[0;33m    Create new 'buildah container' named distroless_hello_world_img \033[0m"
set -o errexit
buildah from \
--name distroless_hello_world_img \
gcr.io/distroless/static-debian12

buildah config \
--author=github.com/bestia-dev \
--label name=distroless_hello_world_img \
--label source=github.com/bestia-dev/docker_rust_development \
distroless_hello_world_img

echo "\033[0;33m    Copy the executable binary file statically linked to musl.  \033[0m"
buildah copy distroless_hello_world_img  'rust_dev_hello_musl' '/usr/bin/rust_dev_hello_musl'

echo "\033[0;33m    Copy the executable binary file dynamically linked to glibc. It will fail to run.  \033[0m"
buildah copy distroless_hello_world_img  'rust_dev_hello_glibc' '/usr/bin/rust_dev_hello_glibc'

echo " "
echo "\033[0;33m    Finally save/commit the image named distroless_hello_world_img \033[0m"
buildah commit distroless_hello_world_img docker.io/bestiadev/distroless_hello_world_img

echo " "
echo "\033[0;33m    Command to start the container and the program: \033[0m"
echo "\033[0;33m    The first executable will run normally because of musl. \033[0m"
echo "\033[0;32m podman run distroless_hello_world_img /usr/bin/rust_dev_hello_musl \033[0m"
echo "\033[0;33m    The second executable will fail because the glibc is missing in distroless. \033[0m"
echo "\033[0;32m podman run distroless_hello_world_img /usr/bin/rust_dev_hello_glibc \033[0m"
echo " "