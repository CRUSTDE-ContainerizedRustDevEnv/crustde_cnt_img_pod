#!/usr/bin/env bash

echo " "
echo "Bash script to restart the pod rust_dev_pod after reboot"
echo "https://github.com/bestia-dev/docker_rust_development"


podman pod restart rust_dev_pod
podman exec -it --user=root  rust_dev_vscode_cnt service ssh restart
