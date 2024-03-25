#!/bin/sh

echo " "
echo "\033[0;33m    Bash script to build the docker image for the Squid proxy server \033[0m"
echo "\033[0;33m    Name of the image: crustde_squid_img \033[0m"
# repository: https://github.com/CRUSTDE-Containerized-Rust-Dev-Env/crustde_cnt_img_pod

echo "\033[0;33m    Squid proxy for restricting outbound network access of containers in the same 'pod'. \033[0m"
echo "\033[0;33m    Modifies the squid.conf file of the official Squid image. \033[0m"
echo "\033[0;33m    This container is used inside a Podman 'pod' with the container crustde_vscode_img \033[0m"

echo "\033[0;33m    To build the image, run in bash with: \033[0m"
echo "\033[0;33m sh crustde_squid_img.sh \033[0m"

echo " "
echo "\033[0;33m    removing container and image if exists \033[0m"
# Be careful, this container is not meant to have persistent data.
# the '|| :' in combination with 'set -e' means that 
# the error is ignored if the container does not exist.
set -e
podman rm -f crustde_squid_cnt || :
buildah rm crustde_squid_img || :
buildah rmi -f docker.io/bestiadev/crustde_squid_img || :

echo " "
echo "\033[0;33m    Create new 'buildah container' named crustde_squid_img from sameersbn/squid:latest \033[0m"
set -o errexit
buildah from \
--name crustde_squid_img \
docker.io/sameersbn/squid:3.5.27-2

echo "\033[0;33m    podman image tree docker.io/sameersbn/squid:3.5.27-2 \033[0m"
podman image tree docker.io/sameersbn/squid:3.5.27-2

buildah config \
--author=github.com/bestia-dev \
--label name=crustde_squid_img \
--label version=squid-3.5.27-2 \
--label source=github.com/CRUSTDE-Containerized-Rust-Dev-Env/crustde_cnt_img_pod \
crustde_squid_img

echo " "
echo "\033[0;33m    Copy squid.conf \033[0m"
buildah copy crustde_squid_img 'etc_squid_squid.conf' '/etc/squid/squid.conf'

echo " "
echo "\033[0;33m    Remove unwanted files \033[0m"
buildah run --user root crustde_squid_img    apt -y autoremove
buildah run --user root crustde_squid_img    apt -y clean

echo " "
echo "\033[0;33m    Finally save/commit the image named crustde_squid_img \033[0m"
buildah commit --squash crustde_squid_img docker.io/bestiadev/crustde_squid_img:latest

buildah tag docker.io/bestiadev/crustde_squid_img:latest docker.io/bestiadev/crustde_squid_img:squid-3.5.27-2

echo " "
echo "\033[0;33m    Upload the new image to docker hub. \033[0m"
echo "\033[0;33m    First you need to store the credentials with: \033[0m"
echo "\033[0;32m podman login --username bestiadev docker.io \033[0m"
echo "\033[0;33m    then type docker access token. \033[0m"
echo "\033[0;32m podman push docker.io/bestiadev/crustde_squid_img:squid-3.5.27-2 \033[0m"
echo "\033[0;32m podman push docker.io/bestiadev/crustde_squid_img:latest \033[0m"

echo " "
echo "\033[0;33m    To create the 'pod' with 'crustde_squid_cnt' and 'crustde_vscode_cnt' use something similar to: \033[0m"
echo "\033[0;32m cd ~/rustprojects/crustde_install/pod_with_rust_vscode  \033[0m"
echo "\033[0;32m sh crustde_pod_create.sh \033[0m"

echo " "
echo "\033[0;33m    Open VSCode, press F1, type 'ssh' and choose 'Remote-SSH: Connect to Host...' and choose 'crustde_vscode_cnt' \033[0m" 
echo "\033[0;33m    Type the passphrase. This will open a new VSCode window attached to the container. \033[0m"
echo "\033[0;33m    Open the VSCode terminal with Ctrl+J \033[0m"
echo "\033[0;33m    Try the if the proxy restrictions work: \033[0m"
echo "\033[0;32m curl --proxy 127.0.0.1:3128 http://httpbin.org/ip \033[0m"
echo "origin: 127.0.0.1, 46.123.241.93"
echo "\033[0;32m curl --proxy 127.0.0.1:3128 http://google.com \033[0m"
echo "curl: (7) Failed to connect to 127.0.0.1 port 3128: Connection refused"
echo " "