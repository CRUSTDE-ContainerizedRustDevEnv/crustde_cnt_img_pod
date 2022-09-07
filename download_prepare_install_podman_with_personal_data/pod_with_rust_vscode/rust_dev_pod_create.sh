#!/bin/sh

# README:

echo " "
echo "\033[0;33m    Bash script to create the pod 'rust_dev_pod': 'sh rust_dev_pod_create.sh' \033[0m"
echo "\033[0;33m    This 'pod' is made of 2 containers: 'rust_dev_squid_cnt' and 'rust_dev_vscode_cnt' \033[0m"
echo "\033[0;33m    It contains Rust, cargo, rustc and VSCode development environment' \033[0m"
echo "\033[0;33m    All outbound network traffic from rust_dev_vscode_cnt goes through the proxy Squid. \033[0m"
echo "\033[0;33m    Published inbound network ports are 8001 on 'localhost' \033[0m"
# repository: https://github.com/bestia-dev/docker_rust_development

# Start of script actions:

echo " "
echo "\033[0;33m    Create pod \033[0m"
# in a "pod" the "publish port" is tied to the pod and not containers.
# http connection     8001
# ssh connection      2201

podman pod create \
-p 127.0.0.1:8001:8001/tcp \
-p 127.0.0.1:2201:2201/tcp \
--label name=rust_dev_pod \
--label version=1.0 \
--label source=github.com/bestia-dev/docker_rust_development \
--label author=github.com/bestia-dev \
--name rust_dev_pod

echo " "
echo "\033[0;33m    Create container rust_dev_squid_cnt in the pod \033[0m"
podman create --name rust_dev_squid_cnt \
--pod=rust_dev_pod -ti \
docker.io/bestiadev/rust_dev_squid_img:latest

echo " "
echo "\033[0;33m    Create container rust_dev_vscode_cnt in the pod \033[0m"
podman create --name rust_dev_vscode_cnt --pod=rust_dev_pod -ti \
--env http_proxy=http://localhost:3128 \
--env https_proxy=http://localhost:3128 \
--env all_proxy=http://localhost:3128  \
docker.io/bestiadev/rust_dev_vscode_img:latest

echo "\033[0;33m    Copy SSH server config \033[0m"
podman cp ./etc_ssh_sshd_config.conf rust_dev_vscode_cnt:/etc/ssh/sshd_config
echo "\033[0;33m    Copy the files for host keys ed25519 for SSH server in rust_dev_pod \033[0m"
podman cp ~/.ssh/rust_dev_pod_keys/etc/ssh/ssh_host_ed25519_key  rust_dev_vscode_cnt:/etc/ssh/ssh_host_ed25519_key
podman cp ~/.ssh/rust_dev_pod_keys/etc/ssh/ssh_host_ed25519_key.pub  rust_dev_vscode_cnt:/etc/ssh/ssh_host_ed25519_key.pub
echo "\033[0;33m    Copy the public key of rustdevuser \033[0m"
podman cp ~/.ssh/rustdevuser_key.pub rust_dev_vscode_cnt:/home/rustdevuser/.ssh/rustdevuser_key.pub

echo "\033[0;33m    podman pod start \033[0m"
podman pod start rust_dev_pod
echo "\033[0;33m    User permissions: \033[0m"

# check the copied files
# TODO: this commands return a WARN[0000] Error resizing exec session 
# that looks like a bug in podman
podman exec --user=rustdevuser rust_dev_vscode_cnt cat /etc/ssh/sshd_config
# podman exec --user=rustdevuser rust_dev_vscode_cnt cat /etc/ssh/ssh_host_ed25519_key
podman exec --user=rustdevuser rust_dev_vscode_cnt cat /etc/ssh/ssh_host_ed25519_key.pub
# always is the problem in permissions
# Chmod 700 (chmod a+rwx,g-rwx,o-rwx) sets permissions so that, 
# (U)ser / owner can read, can write and can execute. 
# (G)roup can't read, can't write and can't execute. 
# (O)thers can't read, can't write and can't execute.
podman exec --user=rustdevuser rust_dev_vscode_cnt chmod 700 /home/rustdevuser/.ssh
podman exec --user=rustdevuser rust_dev_vscode_cnt cat /home/rustdevuser/.ssh/rustdevuser_key.pub

echo "\033[0;33m add rustdevuser_key to authorized_keys \033[0m"
podman exec --user=rustdevuser rust_dev_vscode_cnt touch /home/rustdevuser/.ssh/authorized_keys
# Chmod 600 (chmod a+rwx,u-x,g-rwx,o-rwx) sets permissions so that, 
# (U)ser / owner can read, can write and can't execute. 
# (G)roup can't read, can't write and can't execute. 
# (O)thers can't read, can't write and can't execute.
podman exec --user=rustdevuser rust_dev_vscode_cnt chmod 600 /home/rustdevuser/.ssh/authorized_keys
podman exec --user=rustdevuser rust_dev_vscode_cnt /bin/sh -c 'cat /home/rustdevuser/.ssh/rustdevuser_key.pub >> /home/rustdevuser/.ssh/authorized_keys'
podman exec --user=rustdevuser rust_dev_vscode_cnt cat /home/rustdevuser/.ssh/authorized_keys

echo "\033[0;33m    I have to disable the password for rustdevuser to enable SSH access with public key? Why? \033[0m"
podman exec --user=root rust_dev_vscode_cnt usermod --password '*' rustdevuser

echo "\033[0;33m    Git global config \033[0m"
podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global pull.rebase false

echo "\033[0;33m    Start the SSH server \033[0m"
podman exec --user=root  rust_dev_vscode_cnt service ssh restart

echo "\033[0;33m    Remove the known_hosts for this pod/container. \033[0m"
ssh-keygen -f ~/.ssh/known_hosts -R "[localhost]:2201";

echo "\033[0;33m  Copy the personal files, SSH keys for github or publish-to-web,... \033[0m"
sh ~/.ssh/personal_keys_and_settings.sh

# this step only for WSL:
if grep -qi microsoft /proc/version; then
    echo " "
    echo "\033[0;33m    To start this 'pod' after a reboot of WSL/Windows use this bash script:  \033[0m"
    echo "\033[0;32m sh ~/rustprojects/docker_rust_development/rust_dev_pod_after_wsl_reboot.sh \033[0m"
    echo "\033[0;33m    If you have already used it, you can find it in the bash history:  \033[0m"
    echo "\033[0;32m Ctrl-R, type after, press Tab, press Enter  \033[0m"
    echo "\033[0;33m    You can force the WSL reboot: Open powershell as Administrator:  \033[0m"
    echo "\033[0;32m  Get-Service LxssManager | Restart-Service \033[0m"
fi

echo " "
echo "\033[0;33m    Open VSCode, press F1, type 'ssh' and choose 'Remote-SSH: Connect to Host...' and choose 'rust_dev_vscode_cnt' \033[0m" 
echo "\033[0;33m    Type the passphrase. This will open a new VSCode windows attached to the container. \033[0m"
echo "\033[0;33m    If needed Open VSCode terminal with Ctrl+J \033[0m"
echo "\033[0;33m    Inside VSCode terminal, go to the project folder. Here we will create a sample project: \033[0m"
echo "\033[0;32m cd ~/rustprojects \033[0m"
echo "\033[0;32m cargo new rust_dev_hello \033[0m"
echo "Created binary (application) `rust_dev_hello` package"
echo "\033[0;33m    Secondly: open a new VSCode window exactly for this project/folder. \033[0m"
echo "\033[0;32m code rust_dev_hello \033[0m"
echo "\033[0;33m    A new VSCode windows will open for the 'rust_dev_hello' project. Retype the passphrase. \033[0m"
echo "\033[0;33m    You can close now all other VSCode windows. \033[0m"

echo " "
echo "\033[0;33m    Build and run the project in the VSCode terminal: \033[0m"
echo "\033[0;32m cargo run \033[0m"

echo "Compiling rust_dev_hello v0.1.0 (/home/rustdevuser/rustprojects/rust_dev_hello)"
echo "Finished dev [unoptimized + debuginfo] target(s) in 3.77s"
echo "Running `target/debug/rust_dev_hello`"
echo "Hello, world!"

echo " "
echo "\033[0;33m    You can delete the pod and ALL of the DATA it contains: \033[0m"
echo "\033[0;32m podman pod rm -f rust_dev_pod \033[0m"
