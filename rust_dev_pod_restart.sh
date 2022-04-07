#!/usr/bin/env bash

echo " "
echo "Bash script to restart the pod rust_dev_pod_create after reboot"
echo "repository: https://github.com/bestia-dev/docker_rust_development"


podman pod restart rust_dev_pod_create
podman exec --user=root  rust_dev_vscode_cnt service ssh restart
