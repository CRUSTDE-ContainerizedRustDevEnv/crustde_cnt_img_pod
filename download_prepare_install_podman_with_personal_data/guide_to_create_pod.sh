#!/bin/sh

# this is used inside the scripts
echo ""
echo "\033[0;33m    Now you can create your pod. \033[0m"
echo "\033[0;33m    You can choose between 3 pods. You cannot use them simultaneously. You have to choose only one."
echo "\033[0;33m    If the pod already exists remove it with: \033[0m"
echo "\033[0;32m podman pod rm rust_dev_pod \033[0m"
echo "\033[0;33m    1. pod with rust and vscode: \033[0m"
echo "\033[0;32m sh ~/rustprojects/docker_rust_development_install/pod_with_rust_vscode/rust_dev_pod_create.sh \033[0m"
echo "\033[0;33m    2. pod with rust, postgres and vscode: \033[0m"
echo "\033[0;32m sh ~/rustprojects/docker_rust_development_install/pod_with_rust_pg_vscode/rust_pg_dev_pod_create.sh \033[0m"
echo "\033[0;33m    3. pod with rust, typescript and vscode: \033[0m"
echo "\033[0;32m sh ~/rustprojects/docker_rust_development_install/pod_with_rust__ts_vscode/rust_ts_dev_pod_create.sh \033[0m"

echo ""
echo "\033[0;33m    Check if the containers are started correctly \033[0m"
echo "\033[0;33m podman ps \033[0m"
echo "\033[0;33m    Every container must be started x seconds ago and not only created ! \033[0m"
echo "\033[0;33m    Follow the instructions from README.md to create the pod and connect to it over SSH. \033[0m"