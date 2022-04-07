#!/usr/bin/env bash

echo " "
echo "Bash script to restart the pod rust_dev_pod_after_reboot"
echo "repository: https://github.com/bestia-dev/docker_rust_development"

rm -rf /tmp/podman-run-$(id -u)/libpod/tmp
# if repeated 3 times, the problems vanishes. Maybe because we have 3 containers in the pod.
podman pod restart rust_dev_pod
podman pod restart rust_dev_pod
podman pod restart rust_dev_pod
podman exec --user=root  rust_dev_vscode_cnt service ssh restart
podman pod list
podman ps -a

echo " "
echo "Test the SSH connection from WSL2 terminal:"
echo "ssh -i ~/.ssh/rustdevuser_key -p 2201 rustdevuser@localhost"
echo " "
