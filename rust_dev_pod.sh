#!/usr/bin/env bash

echo " "
echo "Bash script to create and start rust_dev_pod"
echo "This 'pod' contains rust_dev_squid_cnt and rust_dev_vscode_cnt"
echo "All network traffic from rust_dev_vscode_cnt goes through the proxy Squid."
echo "https://github.com/LucianoBestia/docker_rust_development"


podman pod create --name rust_dev_pod
podman create --name squid_cnt --pod=rust_dev_pod -ti --restart=always localhost/rust_dev_squid_img
podman start squid_cnt
podman create --name rust_dev_cnt --pod=rust_dev_pod -ti --env http_proxy=localhost:3128 --env https_proxy=localhost:3128 --env all_proxy=localhost:3128  rust_dev_vscode_img
podman start rust_dev_cnt
