#!/usr/bin/env bash

echo " "
echo "Bash script to create and start the pod 'rust_dev_pod'"
echo "This 'pod' is made of the containers 'rust_dev_squid_cnt' and 'rust_dev_vscode_cnt'"
echo "All outbound network traffic from rust_dev_vscode_cnt goes through the proxy Squid."
echo "Published inbound network ports are 8001 on 'localhost'"
echo "https://github.com/bestia-dev/docker_rust_development"

echo " "
echo "Create pod"
# in a "pod" the "publish port" is tied to the pod and not containers.

podman pod create \
-p 127.0.0.1:8001:8001/tcp \
--label name=rust_dev_pod \
--label version=1.0 \
--label source=github.com/bestia-dev/docker_rust_development \
--label author=github.com/bestia-dev \
--name rust_dev_pod

echo " "
echo "Create container rust_dev_squid_cnt"
# why is here --restart=always
podman create --name rust_dev_squid_cnt --pod=rust_dev_pod -ti \
docker.io/bestiadev/rust_dev_squid_img:latest

podman start rust_dev_squid_cnt

echo " "
echo "Create container rust_dev_vscode_cnt"
podman create --name rust_dev_vscode_cnt --pod=rust_dev_pod -ti \
--env http_proxy=http://localhost:3128 \
--env https_proxy=http://localhost:3128 \
--env all_proxy=http://localhost:3128  \
docker.io/bestiadev/rust_dev_vscode_img:latest

podman start rust_dev_vscode_cnt

echo " "
echo "To start this 'pod' after a reboot, just type: "
echo " podman pod start rust_dev_pod"

echo " "
echo " Firstly: attach VSCode to the running container."
echo "Open VSCode, press F1, type 'attach' and choose 'Remote-Containers:Attach to Running container...' and type rust_dev_vscode_cnt" 
echo " This will open a new VSCode windows attached to the container."
echo " If needed Open VSCode terminal with Ctrl+J"
echo " Inside VSCode terminal, go to the project folder. Here we will create a sample project:"
echo "cd ~/rustprojects"
echo "cargo new rust_dev_hello"
echo "cd ~/rustprojects/rust_dev_hello"

echo " "
echo " Secondly: open a new VSCode window exactly for this project/folder."
echo "code ."
echo " A new VSCode windows will open for the 'rust_dev_hello' project. You can close now all other VSCode windows."

echo " "
echo " Build and run the project in the VSCode terminal:"
echo "cargo run"

echo " "
echo " If you need ssh for git or publish_to_web, inside the VSCode terminal run the ssh-agent:"
echo "eval $(ssh-agent) "
echo "ssh-add /home/rustdevuser/.ssh/certssh1"
echo "ssh-add /home/rustdevuser/.ssh/certssh2"

