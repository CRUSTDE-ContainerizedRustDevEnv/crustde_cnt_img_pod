#!/usr/bin/env bash

echo " "
echo "Bash script to create and start the pod 'rust_dev_pod'"
echo "This 'pod' is made of the containers 'rust_dev_squid_cnt' and 'rust_dev_vscode_cnt'"
echo "All outbound network traffic from rust_dev_vscode_cnt goes through the proxy Squid."
echo "Published inbound network ports are from 8001 to 8009 on 'localhost'"
echo "https://github.com/LucianoBestia/docker_rust_development"

echo " "
echo "Create pod"
# in a "pod" the "publish port" is tied to the pod and not containers.

podman pod create \
-p 127.0.0.1:8001-8009:8001-8009/tcp \
--label name=rust_dev_pod \
--label version=1.0 \
--label source=github.com/LucianoBestia/docker_rust_development \
--label author=github.com/LucianoBestia \
--name rust_dev_pod

echo " "
echo "Create container squid_cnt"
# why is here --restart=always
podman create --name squid_cnt --pod=rust_dev_pod -ti localhost/rust_dev_squid_img
podman start squid_cnt

echo " "
echo "Create container rust_dev_cnt"
podman create --name rust_dev_cnt --pod=rust_dev_pod -ti \
--env http_proxy=localhost:3128 \
--env https_proxy=localhost:3128 \
--env all_proxy=localhost:3128  \
rust_dev_vscode_img

podman start rust_dev_cnt

echo " "
echo "To start this 'pod' after a reboot, just type: "
echo " podman pod start rust_dev_pod"
